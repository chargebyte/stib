CC ?= gcc
PROGRAMS = ptgen

all: $(PROGRAMS)

ptgen: ptgen.c
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f $(PROGRAMS)
