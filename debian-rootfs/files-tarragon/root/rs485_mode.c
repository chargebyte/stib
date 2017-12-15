/*
 * Test program Linux RS485-mode ioctls.
 *
 * cc -o rs485_mode rs485_mode.c
 */

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <linux/serial.h>

int main( int argc, char **argv )
{
        unsigned int i;

        if( argc < 2 ) {
                printf("Usage:  %s [port name] [0|1]\n", argv[0]);
                exit(0);
        }

        int enable;
        char *port = argv[1];

        int fd = open(port, O_RDWR);
        if (fd < 0) {
          /* Error handling. See errno. */
                fprintf( stderr, "Error opening port \"%s\" (%d): %s\n", port, errno, strerror( errno ));
                exit(-1);
        }

        struct serial_rs485 rs485conf;

        if (ioctl (fd, TIOCGRS485, &rs485conf) < 0) {
                fprintf( stderr, "Error reading ioctl port (%d): %s\n",  errno, strerror( errno ));
        }

        printf("Port currently RS485 mode is %s\n", (rs485conf.flags & SER_RS485_ENABLED) ? "set" : "NOT set");

	if ( argc > 2 ) {
		if( atoi( argv[2] ) ) {
		        printf("RS485 mode will be SET\n");
		        rs485conf.flags |= SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND;
		} else {
		        printf("RS485 mode will be UNSET\n");
		        rs485conf.flags &= ~SER_RS485_ENABLED;
		}

		if (ioctl (fd, TIOCSRS485, &rs485conf) < 0) {
		        fprintf( stderr, "Error sending ioctl port (%d): %s\n",  errno, strerror( errno ));
		}
	}

        /* Close the device when finished: */
        if (close (fd) < 0) {
                fprintf( stderr, "Error closing port (%d): %s\n", errno, strerror( errno ));
        }

        exit(0);
}
