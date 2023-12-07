CC = gcc
LD = ld
OBJCOPY = objcopy

CFLAGS = -m32
LDFLAGS = -nostdlib

OBJECTS = $(patsubst source/%.S, %.o, $(wildcard source/*.S))

all: firmware.rom

clean:
	@-rm -f -v *.o firmware.bin firmware.rom

%.o: source/%.S
	$(CC) -c -o $@ $(CFLAGS) $<

firmware.bin: $(OBJECTS)
	$(LD) $(LDFLAGS) -Tsource/link-i8086-pc.ld -o $@ $(OBJECTS)

firmware.rom: firmware.bin
	$(OBJCOPY) -O binary -j .begin -j .main -j .reset --gap-fill=0x0ff $< $@

.PHONY: all clean