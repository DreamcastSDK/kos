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
	@$(GCCPREFIX)-objcopy -O binary $< $@

$(TARGET).elf: $(OBJS)
	@echo Linking: $@
	@$(GCCPREFIX)-gcc -Wl,-Ttext,0x00000000,-Map,$(TARGET).map,-N -nostartfiles -nostdlib -e reset -o $@ $(OBJS) -lgcc

%.o: %.c
	@echo Building: $@
	@$(GCCPREFIX)-gcc -std=c11 -c $< -o $@

%.o: %.s
	@echo Building: $@
	@$(GCCPREFIX)-as $< -o $@

%.o: %.S
	@echo Building: $@
	@$(GCCPREFIX)-as $< -o $@

install:
	@mv $(TARGET).bin ..

clean:
	@rm -f $(OBJS) $(TARGET).elf $(TARGET).map $(TARGET).bin
