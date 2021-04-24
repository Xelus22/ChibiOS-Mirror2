[#ftl]
[#--
    ChibiOS - Copyright (C) 2006..2020 Giovanni Di Sirio.

    This file is part of ChibiOS.

    ChibiOS is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    ChibiOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  --]
[@pp.dropOutputFile /]
[#import "/@lib/libutils.ftl" as utils /]
[#import "/@lib/liblicense.ftl" as license /]
[@pp.changeOutputFile name="mcuconf.h" /]
/*
[@license.EmitLicenseAsText /]
*/

/*
 * STM32WB55xx drivers configuration.
 * The following settings override the default settings present in
 * the various device driver implementation headers.
 * Note that the settings for each driver only have effect if the whole
 * driver is enabled in halconf.h.
 *
 * IRQ priorities:
 * 15...0       Lowest...Highest.
 *
 * DMA priorities:
 * 0...3        Lowest...Highest.
 */

#ifndef MCUCONF_H
#define MCUCONF_H

#define STM32WBxx_MCUCONF
#define STM32WB55_MCUCONF

/*
 * HAL driver system settings.
 */
#define STM32_NO_INIT                       ${doc.STM32_NO_INIT!"FALSE"}
#define STM32_VOS                           ${doc.STM32_VOS!"STM32_VOS_RANGE1"}
#define STM32_PVD_ENABLE                    ${doc.STM32_PVD_ENABLE!"FALSE"}
#define STM32_PLS                           ${doc.STM32_PLS!"STM32_PLS_LEV0"}
#define STM32_HSI16_ENABLED                 ${doc.STM32_HSI16_ENABLED!"TRUE"}
#define STM32_HSI48_ENABLED                 ${doc.STM32_HSI48_ENABLED!"FALSE"}
#define STM32_LSI_ENABLED                   ${doc.STM32_LSI_ENABLED!"TRUE"}
#define STM32_HSE_ENABLED                   ${doc.STM32_HSE_ENABLED!"FALSE"}
#define STM32_LSE_ENABLED                   ${doc.STM32_LSE_ENABLED!"FALSE"}
#define STM32_MSIPLL_ENABLED                ${doc.STM32_MSIPLL_ENABLED!"FALSE"}
#define STM32_MSIRANGE                      ${doc.STM32_MSIRANGE!"STM32_MSIRANGE_4M"}
#define STM32_SW                            ${doc.STM32_SW!"STM32_SW_PLL"}
#define STM32_PLLSRC                        ${doc.STM32_PLLSRC!"STM32_PLLSRC_MSI"}
#define STM32_PLLM_VALUE                    ${doc.STM32_PLLM_VALUE!"1"}
#define STM32_PLLN_VALUE                    ${doc.STM32_PLLN_VALUE!"32"}
#define STM32_PLLP_VALUE                    ${doc.STM32_PLLP_VALUE!"2"}
#define STM32_PLLQ_VALUE                    ${doc.STM32_PLLQ_VALUE!"2"}
#define STM32_PLLR_VALUE                    ${doc.STM32_PLLR_VALUE!"2"}
#define STM32_HPRE                          ${doc.STM32_HPRE!"STM32_HPRE_DIV1"}
#define STM32_PPRE1                         ${doc.STM32_PPRE1!"STM32_PPRE1_DIV1"}
#define STM32_PPRE2                         ${doc.STM32_PPRE2!"STM32_PPRE2_DIV1"}
#define STM32_C2HPRE                        ${doc.STM32_C2HPRE!"STM32_C2HPRE_DIV2"}
#define STM32_SHDHPRE                       ${doc.STM32_SHDHPRE!"STM32_SHDHPRE_DIV1"}
#define STM32_STOPWUCK                      ${doc.STM32_STOPWUCK!"STM32_STOPWUCK_MSI"}
#define STM32_MCOSEL                        ${doc.STM32_MCOSEL!"STM32_MCOSEL_NOCLOCK"}
#define STM32_MCOPRE                        ${doc.STM32_MCOPRE!"STM32_MCOPRE_DIV1"}
#define STM32_LSCOSEL                       ${doc.STM32_LSCOSEL!"STM32_LSCOSEL_NOCLOCK"}
#define STM32_PLLSAI1N_VALUE                ${doc.STM32_PLLSAI1N_VALUE!"24"}
#define STM32_PLLSAI1P_VALUE                ${doc.STM32_PLLSAI1P_VALUE!"2"}
#define STM32_PLLSAI1Q_VALUE                ${doc.STM32_PLLSAI1Q_VALUE!"2"}
#define STM32_PLLSAI1R_VALUE                ${doc.STM32_PLLSAI1R_VALUE!"2"}

/*
 * Peripherals clock sources.
 */
#define STM32_USART1SEL                     ${doc.STM32_USART1SEL!"STM32_USART1SEL_PCLK2"}
#define STM32_LPUART1SEL                    ${doc.STM32_LPUART1SEL!"STM32_LPUART1SEL_PCLK1"}
#define STM32_I2C1SEL                       ${doc.STM32_I2C1SEL!"STM32_I2C1SEL_PCLK1"}
#define STM32_I2C3SEL                       ${doc.STM32_I2C3SEL!"STM32_I2C3SEL_PCLK1"}
#define STM32_LPTIM1SEL                     ${doc.STM32_LPTIM1SEL!"STM32_LPTIM1SEL_PCLK1"}
#define STM32_LPTIM2SEL                     ${doc.STM32_LPTIM2SEL!"STM32_LPTIM2SEL_PCLK1"}
#define STM32_SAI1SEL                       ${doc.STM32_SAI1SEL!"STM32_SAI1SEL_OFF"}
#define STM32_CLK48SEL                      ${doc.STM32_CLK48SEL!"STM32_CLK48SEL_PLLSAI1"}
#define STM32_ADCSEL                        ${doc.STM32_ADCSEL!"STM32_ADCSEL_SYSCLK"}
#define STM32_RTCSEL                        ${doc.STM32_RTCSEL!"STM32_RTCSEL_LSI"}

/*
 * IRQ system settings.
 */
#define STM32_IRQ_EXTI0_PRIORITY            ${doc.STM32_IRQ_EXTI0_PRIORITY!"6"}
#define STM32_IRQ_EXTI1_PRIORITY            ${doc.STM32_IRQ_EXTI1_PRIORITY!"6"}
#define STM32_IRQ_EXTI2_PRIORITY            ${doc.STM32_IRQ_EXTI2_PRIORITY!"6"}
#define STM32_IRQ_EXTI3_PRIORITY            ${doc.STM32_IRQ_EXTI3_PRIORITY!"6"}
#define STM32_IRQ_EXTI4_PRIORITY            ${doc.STM32_IRQ_EXTI4_PRIORITY!"6"}
#define STM32_IRQ_EXTI5_9_PRIORITY          ${doc.STM32_IRQ_EXTI5_9_PRIORITY!"6"}
#define STM32_IRQ_EXTI10_15_PRIORITY        ${doc.STM32_IRQ_EXTI10_15_PRIORITY!"6"}
#define STM32_IRQ_EXTI16_31_33_PRIORITY     ${doc.STM32_IRQ_EXTI1635_38_PRIORITY!"6"}
#define STM32_IRQ_EXTI17_PRIORITY           ${doc.STM32_IRQ_EXTI17_PRIORITY!"6"}
#define STM32_IRQ_EXTI18_PRIORITY           ${doc.STM32_IRQ_EXTI18_PRIORITY!"6"}
#define STM32_IRQ_EXTI19_PRIORITY           ${doc.STM32_IRQ_EXTI19_PRIORITY!"6"}
#define STM32_IRQ_EXTI20_21_PRIORITY        ${doc.STM32_IRQ_EXTI21_22_PRIORITY!"6"}

#define STM32_IRQ_TIM1_BRK_PRIORITY         ${doc.STM32_IRQ_TIM1_BRK_TIM15_PRIORITY!"7"}
#define STM32_IRQ_TIM1_UP_TIM16_PRIORITY    ${doc.STM32_IRQ_TIM1_UP_TIM16_PRIORITY!"7"}
#define STM32_IRQ_TIM1_TRGCO_TIM17_PRIORITY ${doc.STM32_IRQ_TIM1_TRGCO_TIM17_PRIORITY!"7"}
#define STM32_IRQ_TIM1_CC_PRIORITY          ${doc.STM32_IRQ_TIM1_CC_PRIORITY!"7"}
#define STM32_IRQ_TIM2_PRIORITY             ${doc.STM32_IRQ_TIM2_PRIORITY!"7"}
#define STM32_IRQ_TIM16_PRIORITY            ${doc.STM32_IRQ_TIM16_PRIORITY!"7"}
#define STM32_IRQ_TIM17_PRIORITY            ${doc.STM32_IRQ_TIM17_PRIORITY!"7"}

#define STM32_IRQ_USART1_PRIORITY           ${doc.STM32_IRQ_USART1_PRIORITY!"12"}
#define STM32_IRQ_LPUART1_PRIORITY          ${doc.STM32_IRQ_LPUART1_PRIORITY!"12"}

/*
 * ADC driver system settings.
 */
#define STM32_ADC_COMPACT_SAMPLES           ${doc.STM32_ADC_COMPACT_SAMPLES!"FALSE"}
#define STM32_ADC_USE_ADC1                  ${doc.STM32_ADC_USE_ADC1!"FALSE"}
#define STM32_ADC_ADC1_DMA_STREAM           ${doc.STM32_ADC_ADC1_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_ADC_ADC1_DMA_PRIORITY         ${doc.STM32_ADC_ADC1_DMA_PRIORITY!"2"}
#define STM32_ADC_ADC1_IRQ_PRIORITY         ${doc.STM32_ADC_ADC1_IRQ_PRIORITY!"5"}
#define STM32_ADC_ADC1_DMA_IRQ_PRIORITY     ${doc.STM32_ADC_ADC1_DMA_IRQ_PRIORITY!"5"}
#define STM32_ADC_ADC1_CLOCK_MODE           ${doc.STM32_ADC_ADC1_CLOCK_MODE!"ADC_CCR_CKMODE_AHB_DIV1"}
#define STM32_ADC_ADC1_PRESC                ${doc.STM32_ADC_ADC1_PRESC!"ADC_CCR_PRESC_DIV2"}

/*
 * GPT driver system settings.
 */
#define STM32_GPT_USE_TIM1                  ${doc.STM32_GPT_USE_TIM1!"FALSE"}
#define STM32_GPT_USE_TIM2                  ${doc.STM32_GPT_USE_TIM2!"FALSE"}
#define STM32_GPT_USE_TIM16                 ${doc.STM32_GPT_USE_TIM16!"FALSE"}
#define STM32_GPT_USE_TIM17                 ${doc.STM32_GPT_USE_TIM17!"FALSE"}

/*
 * I2C driver system settings.
 */
#define STM32_I2C_USE_I2C1                  ${doc.STM32_I2C_USE_I2C1!"FALSE"}
#define STM32_I2C_USE_I2C3                  ${doc.STM32_I2C_USE_I2C3!"FALSE"}
#define STM32_I2C_BUSY_TIMEOUT              ${doc.STM32_I2C_BUSY_TIMEOUT!"50"}
#define STM32_I2C_I2C1_RX_DMA_STREAM        ${doc.STM32_I2C_I2C1_RX_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_I2C_I2C1_TX_DMA_STREAM        ${doc.STM32_I2C_I2C1_TX_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_I2C_I2C3_RX_DMA_STREAM        ${doc.STM32_I2C_I2C3_RX_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_I2C_I2C3_TX_DMA_STREAM        ${doc.STM32_I2C_I2C3_TX_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_I2C_I2C1_IRQ_PRIORITY         ${doc.STM32_I2C_I2C1_IRQ_PRIORITY!"5"}
#define STM32_I2C_I2C3_IRQ_PRIORITY         ${doc.STM32_I2C_I2C3_IRQ_PRIORITY!"5"}
#define STM32_I2C_I2C1_DMA_PRIORITY         ${doc.STM32_I2C_I2C1_DMA_PRIORITY!"3"}
#define STM32_I2C_I2C3_DMA_PRIORITY         ${doc.STM32_I2C_I2C3_DMA_PRIORITY!"3"}
#define STM32_I2C_DMA_ERROR_HOOK(i2cp)      ${doc.STM32_I2C_DMA_ERROR_HOOK!"osalSysHalt(\"DMA failure\")"}

/*
 * ICU driver system settings.
 */
#define STM32_ICU_USE_TIM1                  ${doc.STM32_ICU_USE_TIM1!"FALSE"}
#define STM32_ICU_USE_TIM2                  ${doc.STM32_ICU_USE_TIM2!"FALSE"}

/*
 * PWM driver system settings.
 */
#define STM32_PWM_USE_ADVANCED              ${doc.STM32_PWM_USE_ADVANCED!"FALSE"}
#define STM32_PWM_USE_TIM1                  ${doc.STM32_PWM_USE_TIM1!"FALSE"}
#define STM32_PWM_USE_TIM2                  ${doc.STM32_PWM_USE_TIM2!"FALSE"}
#define STM32_PWM_USE_TIM16                 ${doc.STM32_PWM_USE_TIM16!"FALSE"}
#define STM32_PWM_USE_TIM17                 ${doc.STM32_PWM_USE_TIM17!"FALSE"}

/*
 * RTC driver system settings.
 */
#define STM32_RTC_PRESA_VALUE               ${doc.STM32_RTC_PRESA_VALUE!"32"}
#define STM32_RTC_PRESS_VALUE               ${doc.STM32_RTC_PRESS_VALUE!"1024"}
#define STM32_RTC_CR_INIT                   ${doc.STM32_RTC_CR_INIT!"0"}
#define STM32_RTC_TAMPCR_INIT               ${doc.STM32_RTC_TAMPCR_INIT!"0"}

/*
 * SERIAL driver system settings.
 */
#define STM32_SERIAL_USE_USART1             ${doc.STM32_SERIAL_USE_USART1!"FALSE"}
#define STM32_SERIAL_USE_LPUART1            ${doc.STM32_SERIAL_USE_LPUART1!"FALSE"}
#define STM32_SERIAL_USART1_PRIORITY        ${doc.STM32_SERIAL_USART1_PRIORITY!"12"}
#define STM32_SERIAL_LPUART1_PRIORITY       ${doc.STM32_SERIAL_LPUART1_PRIORITY!"12"}

/*
 * SIO driver system settings.
 */
#define STM32_SIO_USE_USART1                ${doc.STM32_SIO_USE_USART1!"FALSE"}
#define STM32_SIO_USE_LPUART1               ${doc.STM32_SIO_USE_LPUART1!"FALSE"}

/*
 * SPI driver system settings.
 */
#define STM32_SPI_USE_SPI1                  ${doc.STM32_SPI_USE_SPI1!"FALSE"}
#define STM32_SPI_USE_SPI2                  ${doc.STM32_SPI_USE_SPI2!"FALSE"}
#define STM32_SPI_SPI1_RX_DMA_STREAM        ${doc.STM32_SPI_SPI1_RX_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_SPI_SPI1_TX_DMA_STREAM        ${doc.STM32_SPI_SPI1_TX_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_SPI_SPI2_RX_DMA_STREAM        ${doc.STM32_SPI_SPI2_RX_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_SPI_SPI2_TX_DMA_STREAM        ${doc.STM32_SPI_SPI2_TX_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_SPI_SPI1_DMA_PRIORITY         ${doc.STM32_SPI_SPI1_DMA_PRIORITY!"1"}
#define STM32_SPI_SPI2_DMA_PRIORITY         ${doc.STM32_SPI_SPI2_DMA_PRIORITY!"1"}
#define STM32_SPI_SPI1_IRQ_PRIORITY         ${doc.STM32_SPI_SPI1_IRQ_PRIORITY!"10"}
#define STM32_SPI_SPI2_IRQ_PRIORITY         ${doc.STM32_SPI_SPI2_IRQ_PRIORITY!"10"}
#define STM32_SPI_DMA_ERROR_HOOK(spip)      ${doc.STM32_SPI_DMA_ERROR_HOOK!"osalSysHalt(\"DMA failure\")"}

/*
 * ST driver system settings.
 */
#define STM32_ST_IRQ_PRIORITY               ${doc.STM32_ST_IRQ_PRIORITY!"8"}
#define STM32_ST_USE_TIMER                  ${doc.STM32_ST_USE_TIMER!"2"}

/*
 * TRNG driver system settings.
 */
#define STM32_TRNG_USE_RNG1                 ${doc.STM32_TRNG_USE_RNG1!"FALSE"}

/*
 * UART driver system settings.
 */
#define STM32_UART_USE_USART1               ${doc.STM32_UART_USE_USART1!"FALSE"}
#define STM32_UART_USART1_RX_DMA_STREAM     ${doc.STM32_UART_USART1_RX_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_UART_USART1_TX_DMA_STREAM     ${doc.STM32_UART_USART1_TX_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_UART_USART1_IRQ_PRIORITY      ${doc.STM32_UART_USART1_IRQ_PRIORITY!!"12"}
#define STM32_UART_USART1_DMA_PRIORITY      ${doc.STM32_UART_USART1_DMA_PRIORITY!"0"}
#define STM32_UART_DMA_ERROR_HOOK(uartp)    ${doc.STM32_UART_DMA_ERROR_HOOK!"osalSysHalt(\"DMA failure\")"}

/*
 * USB driver system settings.
 */
#define STM32_USB_USE_USB1                  ${doc.STM32_USB_USE_USB1!"FALSE"}
#define STM32_USB_LOW_POWER_ON_SUSPEND      ${doc.STM32_USB_LOW_POWER_ON_SUSPEND!"FALSE"}
#define STM32_USB_USB1_HP_IRQ_PRIORITY      ${doc.STM32_USB_USB1_HP_IRQ_PRIORITY!"12"}
#define STM32_USB_USB1_LP_IRQ_PRIORITY      ${doc.STM32_USB_USB1_LP_IRQ_PRIORITY!"12"}

/*
 * WDG driver system settings.
 */
#define STM32_WDG_USE_IWDG                  ${doc.STM32_WDG_USE_IWDG!"FALSE"}

/*
 * WSPI driver system settings.
 */
#define STM32_WSPI_USE_QUADSPI1             ${doc.STM32_WSPI_USE_QUADSPI1!"FALSE"}
#define STM32_WSPI_QUADSPI1_DMA_STREAM      ${doc.STM32_WSPI_QUADSPI1_DMA_STREAM!"STM32_DMA_STREAM_ID_ANY"}
#define STM32_WSPI_QUADSPI1_PRESCALER_VALUE ${doc.STM32_WSPI_QUADSPI1_PRESCALER_VALUE!"1"}

#endif /* MCUCONF_H */
