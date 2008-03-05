/*
    ChibiOS/RT - Copyright (C) 2006-2007 Giovanni Di Sirio.

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

#include <ch.h>

#include <avr/io.h>

#include "board.h"

void hwinit(void);

static WorkingArea(waThread1, 32);
static msg_t Thread1(void *arg) {

  while (TRUE) {
    PORTA ^= PORTA_RELAY;
    chThdSleep(1000);
  }
  return 0;
}

int main(int argc, char **argv) {

  hwinit();

  /*
   * The main() function becomes a thread here then the interrupts are
   * enabled and ChibiOS/RT goes live.
   */
  chSysInit();

  /*
   * Starts the LED blinker thread.
   */
  chThdCreate(NORMALPRIO, 0, waThread1, sizeof(waThread1), Thread1, NULL);

  while(TRUE)
    chThdSleep(1000);

  return 0;
}
