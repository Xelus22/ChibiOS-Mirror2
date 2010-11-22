/*
    ChibiOS/RT - Copyright (C) 2006,2007,2008,2009,2010 Giovanni Di Sirio.

    This file is part of ChibiOS/RT.

    ChibiOS/RT is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    ChibiOS/RT is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "ch.h"
#include "hal.h"
#include "test.h"

static void pwmpcb(PWMDriver *pwmp);
static void adccb(ADCDriver *adcp, adcsample_t *buffer, size_t n);
static void spicb(SPIDriver *spip);

/* Total number of channels to be sampled by a single ADC operation.*/
#define ADC_GRP1_NUM_CHANNELS   2

/* Depth of the conversion buffer, channels are sampled four times each.*/
#define ADC_GRP1_BUF_DEPTH      4

/*
 * ADC samples buffer.
 */
static adcsample_t samples[ADC_GRP1_NUM_CHANNELS * ADC_GRP1_BUF_DEPTH];

/*
 * ADC conversion group.
 * Mode:        Linear buffer, 4 samples of 2 channels, SW triggered.
 * Channels:    IN10, Sensor.
 */
static const ADCConversionGroup adcgrpcfg = {
  FALSE,
  ADC_GRP1_NUM_CHANNELS,
  adccb,
  0,
  ADC_CR2_EXTSEL_SWSTART | ADC_CR2_TSVREFE | ADC_CR2_CONT,
  0,
  0,
  ADC_SQR1_NUM_CH(ADC_GRP1_NUM_CHANNELS),
  0,
  ADC_SQR3_SQ1_N(ADC_CHANNEL_IN10) | ADC_SQR3_SQ0_N(ADC_CHANNEL_SENSOR)
};

/*
 * ADC configuration structure, empty for STM32, there is nothing to configure.
 */
static const ADCConfig adccfg = {
};

/*
 * PWM configuration structure.
 * Cyclic callback enabled, channels 3 and 4 enabled without callbacks,
 * the active state is a logic one.
 */
static PWMConfig pwmcfg = {
  pwmpcb,
  {
    {PWM_OUTPUT_DISABLED, NULL},
    {PWM_OUTPUT_DISABLED, NULL},
    {PWM_OUTPUT_ACTIVE_HIGH, NULL},
    {PWM_OUTPUT_ACTIVE_HIGH, NULL}
  },
  PWM_COMPUTE_PSC(STM32_TIMCLK1, 10000),    /* 10KHz PWM clock frequency.   */
  PWM_COMPUTE_ARR(10000, 1000000000),       /* PWM period 1S (in nS).       */
  0
};

/*
 * SPI configuration structure.
 * Maximum speed (12MHz), CPHA=0, CPOL=0, 16bits frames, MSb transmitted first.
 * The slave select line is the pin GPIOA_SPI1NSS on the port GPIOA.
 */
static const SPIConfig spicfg = {
  spicb,
  GPIOA,
  GPIOA_SPI1NSS,
  SPI_CR1_DFF
};

/*
 * PWM cyclic callback. PWM channels are reprogrammed using a duty cycle
 * calculated as average of the last sampling operations.
 */
static void pwmpcb(PWMDriver *pwmp) {

  /* Starts an asynchronous ADC conversion operation, the conversion
     will be executed in parallel to the current PWM cycle and will
     terminate before the next PWM cycle.*/
  chSysLockFromIsr();
  adcStartConversionI(&ADCD1, &adcgrpcfg, samples, ADC_GRP1_BUF_DEPTH);
  chSysUnlockFromIsr();
}

/*
 * ADC end conversion callback.
 * The latest samples are transmitted into a single SPI transaction.
 */
void adccb(ADCDriver *adcp, adcsample_t *buffer, size_t n) {

  (void) buffer; (void) n;
  /* Note, only in the ADC_COMPLETE state because the ADC driver fires an
     intermediate callback when the buffer is half full.*/
  if (adcp->ad_state == ADC_COMPLETE) {
    adcsample_t avg_ch1, avg_ch2;

    /* Calculates the average values from the ADC samples.*/
    avg_ch1 = (samples[0] + samples[2] + samples[4] + samples[6]) / 4;
    avg_ch2 = (samples[1] + samples[3] + samples[5] + samples[7]) / 4;

    chSysLockFromIsr();

    /* Changes the channels pulse width, the change will be effective
       starting from the next cycle.*/
    pwmEnableChannelI(&PWMD3, 2, PWM_FRACTION_TO_WIDTH(&PWMD3, 4096, avg_ch1));
    pwmEnableChannelI(&PWMD3, 3, PWM_FRACTION_TO_WIDTH(&PWMD3, 4096, avg_ch2));

    /* SPI slave selection and transmission start.*/
    spiSelectI(&SPID1);
    spiStartSendI(&SPID1, ADC_GRP1_NUM_CHANNELS * ADC_GRP1_BUF_DEPTH, samples);

    chSysUnlockFromIsr();
  }
}

/*
 * SPI end transfer callback.
 */
static void spicb(SPIDriver *spip) {

  /* On transfer end just releases the slave select line.*/
  chSysLockFromIsr();
  spiUnselectI(spip);
  chSysUnlockFromIsr();
}

/*
 * This is a periodic thread that does absolutely nothing except sleeping and
 * increase a counter.
 */
static WORKING_AREA(waThread1, 128);
static msg_t Thread1(void *arg) {
  static uint32_t seconds_counter;

  (void)arg;
  while (TRUE) {
    chThdSleepMilliseconds(1000);
    seconds_counter++;
  }
  return 0;
}

/*
 * Entry point, note, the main() function is already a thread in the system
 * on entry.
 */
int main(int argc, char **argv) {

  (void)argc;
  (void)argv;

  /*
   * Activates the serial driver 1 using the driver default configuration.
   */
  sdStart(&SD1, NULL);

  /*
   * Initializes the SPI driver 1.
   */
  spiStart(&SPID1, &spicfg);

  /*
   * Initializes the ADC driver 1.
   * The pin PC0 on the port GPIOC is programmed as analog input.
   */
  adcStart(&ADCD1, &adccfg);
  palSetGroupMode(GPIOC, PAL_PORT_BIT(0), PAL_MODE_INPUT_ANALOG);

  /*
   * Initializes the PWM driver 1, re-routes the TIM3 outputs, programs the
   * pins as alternate functions and finally enables channels with zero
   * initial duty cycle.
   * Note, the AFIO access routes the TIM3 output pins on the PC6...PC9
   * where the LEDs are connected.
   */
  pwmStart(&PWMD3, &pwmcfg);
  AFIO->MAPR |= AFIO_MAPR_TIM3_REMAP_0 | AFIO_MAPR_TIM3_REMAP_1;
  palSetGroupMode(GPIOC, PAL_PORT_BIT(GPIOC_LED3) | PAL_PORT_BIT(GPIOC_LED4),
                  PAL_MODE_STM32_ALTERNATE_PUSHPULL);

  /*
   * Creates the example thread.
   */
  chThdCreateStatic(waThread1, sizeof(waThread1), NORMALPRIO, Thread1, NULL);

  /*
   * Normal main() thread activity, in this demo it does nothing except
   * sleeping in a loop and check the button state.
   */
  while (TRUE) {
    if (palReadPad(GPIOA, GPIOA_BUTTON))
      TestThread(&SD1);
    chThdSleepMilliseconds(500);
  }
  return 0;
}
