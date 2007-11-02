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

#include "lpc214x.h"
#include "lpc214x_ssp.h"

#include "mmcsd.h"

static EventSource MMCInsertEventSource;

/*
 * Subsystem initialization.
 */
void InitMMC(void) {

  chEvtInit(&MMCInsertEventSource);
}

static void sendhdr(BYTE8 cmd, ULONG32 arg) {
  BYTE8 buf[6];

  /*
   * Wait for the bus to become idle if a write operation was in progress.
   */
  while (TRUE) {
    sspRW(buf, NULL, 1);
    if (buf[0] == 0xFF)
      break;
#ifdef NICE_WAITING
    chThdSleep(1);      /* Trying to be nice with the other threads.*/
#endif
  }

  buf[0] = 0x40 | cmd;
  buf[1] = arg >> 24;
  buf[2] = arg >> 16;
  buf[3] = arg >> 8;
  buf[4] = arg;
  buf[5] = 0x95; /* Valid for CMD0 ingnored by other commands. */
  sspRW(NULL, buf, 6);
}

static BYTE8 recvr1(void) {
  int i;
  BYTE8 r1[1];

  for (i = 0; i < 9; i++) {
    sspRW(r1, NULL, 1);
    if (r1[0] != 0xFF)
      return r1[0];
  }
  return 0xFF;                  /* Timeout.*/
}

static BOOL getdata(BYTE8 *buf, ULONG32 n) {
  int i;

  for (i = 0; i < MMC_WAIT_DATA; i++) {
    sspRW(buf, NULL, 1);
    if (buf[0] == 0xFE) {
      sspRW(buf, NULL, n);
      sspRW(NULL, NULL, 2);     /* CRC ignored.*/
      return FALSE;
    }
  }
  return TRUE;                  /* Timeout.*/
}

/*
 * Initializes a card after the power up by selecting the SPI mode.
 */
BOOL mmcInit(void) {

  /*
   * Starting initialization with slow clock mode.
   */
  SetSSP(254, CR0_DSS8BIT | CR0_FRFSPI | CR0_CLOCKRATE(0), 0);

  /*
   * SPI mode selection.
   */
  sspRW(NULL, NULL, 16);        /* 128 clock pulses without ~CS asserted. */
  int i = 0;
  while (TRUE) {
    if (mmcSendCommand(CMDGOIDLE, 0) == 0x01)
      break;
    if (++i >= CMD0_RETRY)
      return TRUE;
    chThdSleep(10);
  }

  /*
   * Initialization.
   */
  i = 0;
  while (TRUE) {
    BYTE8 b = mmcSendCommand(CMDINIT, 0);
    if (b == 0x00)
      break;
    if (b != 0x01)
      return TRUE;
    if (++i >= CMD1_RETRY)
      return TRUE;
    chThdSleep(10);
  }

  /*
   * Full speed.
   */
  SetSSP(2, CR0_DSS8BIT | CR0_FRFSPI | CR0_CLOCKRATE(0), 0);
  return FALSE;
}

/*
 * Sends a simple command and returns a R1-type response.
 */
BYTE8 mmcSendCommand(BYTE8 cmd, ULONG32 arg) {
  BYTE8 r1;

  sspAcquireBus();
  sendhdr(cmd, arg);
  r1 = recvr1();
  sspReleaseBus();
  return r1;
}

/*
 * Reads the card info record.
 * @param data the pointer to a \p MMCCSD structure
 * @return \p TRUE if an error happened
 */
BOOL mmcGetSize(MMCCSD *data) {
  BYTE8 buf[16];

  sspAcquireBus();
  sendhdr(CMDREADCSD, 0);
  if (recvr1() != 0x00) {
    sspReleaseBus();
    return TRUE;
  }
  if (getdata(buf, 16)) {
    sspReleaseBus();
    return TRUE;
  }
  sspReleaseBus();

  /* csize * multiplier */
  data->csize    = (((buf[6] & 3) << 10) | (buf[7] << 2) | (buf[8] >> 6)) *
                   (1 << (2 + (((buf[9] & 3) << 1) | (buf[10] >> 7))));
  data->rdblklen = 1 << (buf[5] & 15);
  return FALSE;
}

/*
 * Reads a block.
 * @param blknum the block number
 * @param buf the pointer to the read buffer
 * @return \p TRUE if an error happened
 */
BOOL mmcBlockRead(ULONG32 blknum, BYTE8 *buf) {

  sspAcquireBus();
  sendhdr(CMDREAD, blknum << 8);
  if (recvr1() != 0x00) {
    sspReleaseBus();
    return TRUE;
  }
  if (getdata(buf, 512)) {
    sspReleaseBus();
    return TRUE;
  }
  sspReleaseBus();
  return FALSE;
}

/*
 * Writes a block.
 * @param blknum the block number
 * @param buf the pointer to the write buffer
 * @return \p TRUE if an error happened
 * @note The function DOES NOT wait for the SPI bus to become free after
 *       sending the data, the bus check is done before sending commands to
 *       the card, this allows to not make useless busy waiting. The invoking
 *       thread can do other things while the data is being written.
 */
BOOL mmcBlockWrite(ULONG32 blknum, BYTE8 *buf) {
  static BYTE8 start[] = {0xFF, 0xFE};
  BYTE8 b[4];

  sspAcquireBus();
  sendhdr(CMDWRITE, blknum << 8);
  if (recvr1() != 0x00) {
    sspReleaseBus();
    return TRUE;
  }
  sspRW(NULL, start, 2);        /* Data prologue.*/
  sspRW(NULL, buf, 512);        /* Data.*/
  sspRW(NULL, NULL, 2);         /* CRC ignored in this version.*/
  sspRW(b, NULL, 1);
  sspReleaseBus();
  if ((b[0] & 0x1E) != 0x05)
    return TRUE;
  return FALSE;
}

/*
 * Makes sure that pending operations are completed before returning.
 */
void mmcSynch(void) {
  BYTE8 buf[4];

  sspAcquireBus();
  while (TRUE) {
    sspRW(buf, NULL, 1);
    if (buf[0] == 0xFF)
      break;
#ifdef NICE_WAITING
    chThdSleep(1);      /* Trying to be nice with the other threads.*/
#endif
  }
  sspReleaseBus();
}
