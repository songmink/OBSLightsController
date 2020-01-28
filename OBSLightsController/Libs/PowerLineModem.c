//
//  PowerLineModem.c
//  OBSLightsController
//
//  Created by Songmin Kim on 1/23/20.
//  Copyright © 2020 Center for Language & Technology. All rights reserved.
//

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

#include "PowerLineModem.h"

int set_interface_attribs(int fd, int speed)
{
    struct termios tty;

    if (tcgetattr(fd, &tty) < 0) {
        printf("Error from tcgetattr: %s\n", strerror(errno));
        return -1;
    }

    cfsetospeed(&tty, (speed_t)speed);
    cfsetispeed(&tty, (speed_t)speed);

    tty.c_cflag |= (CLOCAL | CREAD);    /* ignore modem controls */
    tty.c_cflag &= ~CSIZE;
    tty.c_cflag |= CS8;         /* 8-bit characters */
    tty.c_cflag &= ~PARENB;     /* no parity bit */
    tty.c_cflag &= ~CSTOPB;     /* only need 1 stop bit */
    tty.c_cflag &= ~CRTSCTS;    /* no hardware flowcontrol */

    /* setup for non-canonical mode */
    tty.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
    tty.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
    tty.c_oflag &= ~OPOST;

    /* fetch bytes as they become available */
    tty.c_cc[VMIN] = 1;
    tty.c_cc[VTIME] = 1;

    if (tcsetattr(fd, TCSANOW, &tty) != 0) {
        printf("Error from tcsetattr: %s\n", strerror(errno));
        return -1;
    }
    return 0;
}

void comm(char msg[], int bit)
{
    int fd;
    int wlen;
    char *portname = "/dev/cu.usbserial-AM00O230";
    
    fd = open(portname, O_RDWR | O_NOCTTY | O_SYNC);
    if (fd < 0) {
        printf("Error opening %s: %s\n", portname, strerror(errno));
    }
    /*baudrate 19200, 8 bits, no parity, 1 stop bit */
    set_interface_attribs(fd, B19200);
    
    wlen = write(fd, msg, bit);
    if (wlen != 8) {
       printf("Error from write: %d, %d\n", wlen, errno);
    }
    tcdrain(fd);    /* delay for output */
}

int allPower(int req)
{
    /* Insteon Info Call*/
    //  char msg[] = {0x02, 0x60};
    // All link on message
    char onMsg[] = {0x02, 0x62, 0x00, 0x00, 0x01, 0xcf, 0x11, 0xff};
    // All link  off message
    char offMsg[] = {0x02, 0x62, 0x00, 0x00, 0x01, 0xcf, 0x13, 0xff};

    // Insteon PLM uses 8 bits
    if (req == 1) {
        // all link on
        comm(onMsg, 8);
        //return lightStatus 1 as on
        return 1;
    } else if (req == 0) {
        // all link off
       comm(offMsg, 8);
        //return lightStatus 0 as off
       return 0;
    } else {
        printf("Error : %s\n", strerror(errno));
        return -1;
    }
}
