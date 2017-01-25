ifneq ($(DEBUG),true)
  QUIET:=@
endif

ifndef PLATFORM
  PLATFORM:=dreamcast
endif

ifndef ARCH
  ARCH:=arm-eabi
endif

OBJS:=aica.o crt0.o main.o
TARGET:=snd_stream_drv

GCCPREFIX:=$(shell echo $(ARCH) | cut -d '-' -f 1)-$(PLATFORM)

$(TARGET).bin: $(TARGET).elf
	@echo Extracting: $@
	$(QUIET) $(GCCPREFIX)-objcopy -O binary $< $@

$(TARGET).elf: $(OBJS)
	@echo Linking: $@
	$(QUIET) $(GCCPREFIX)-gcc -Wl,-Ttext,0x00000000,-Map,$(TARGET).map,-N -nostartfiles -nostdlib -e reset -o $@ $(OBJS) -lgcc

%.o: %.c
	@echo Building: $@
	$(QUIET) $(GCCPREFIX)-gcc -std=c11 -c $< -o $@

%.o: %.s
	@echo Building: $@
	$(QUIET) $(GCCPREFIX)-as $< -o $@

%.o: %.S
	@echo Building: $@
	$(QUIET) $(GCCPREFIX)-as $< -o $@

install:
	$(QUIET) mv $(TARGET).bin ..

clean:
	$(QUIET) rm -f $(OBJS) $(TARGET).elf $(TARGET).map $(TARGET).bin
