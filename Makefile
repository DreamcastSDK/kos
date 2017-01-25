ifndef PLATFORM
  PLATFORM:=dreamcast
endif

ifndef ARCH
  ARCH:=sh-elf
endif

ifndef INSTALL_PATH
  INSTALL_PATH:=/usr/local
endif

OBJS:=$(shell "sh" "filelist.sh")

TARGET:=libkos.a

DEFINES:= \
        -D_arch_$(PLATFORM) \
        -DPLATFORM="$(PLATFORM)"

CFLAGS:=$(DEFINES) \
	-std=c11 \
        -Wall -Wextra \
        -g \
        -fno-builtin \
        -fno-strict-aliasing \
        -fomit-frame-pointer \
        -ffunction-sections \
        -fdata-sections

CFLAGS+=-Icommon/include \
	-Iaddons/include \
	-I$(PLATFORM)/include \
	-I$(INSTALL_PATH)/$(PLATFORM)/$(ARCH)/include

# out-of-band includes
CFLAGS+=-Icommon/net \
	\
	-Iaddons/libppp \
	-Iaddons/libkosutils \
	-Iaddons/libkosext2fs \
	\
	-Idreamcast/hardware/pvr \
	-Idreamcast/hardware/modem \
	-Idreamcast/kernel


GCCPREFIX:=$(shell echo $(ARCH) | cut -d '-' -f 1)-$(PLATFORM)

$(TARGET): $(OBJS)
	@$(GCCPREFIX)-ar rcs $@ $(OBJS)
	@echo Linking: $@

install: $(TARGET)
	@echo -n "Installing..."
	@cp -R common/include/*		$(INSTALL_PATH)/$(PLATFORM)/$(ARCH)/include/
	@cp -R addons/include/*		$(INSTALL_PATH)/$(PLATFORM)/$(ARCH)/include/
	@cp -R $(PLATFORM)/include/*	$(INSTALL_PATH)/$(PLATFORM)/$(ARCH)/include/
	@cp $(TARGET) $(INSTALL_PATH)/$(PLATFORM)/$(ARCH)/lib/

clean:
	@rm -f $(OBJS) $(TARGET)

common/libc/c11/%.o: common/libc/c11/%.c
	@echo Building: $@
	@$(GCCPREFIX)-gcc -std=c11 $(CFLAGS) -c $< -o $@

%.o: %.c
	@echo Building: $@
	@$(GCCPREFIX)-gcc $(CFLAGS) -c $< -o $@

%.o: %.s
	@echo Building: $@
	@$(GCCPREFIX)-as $< -o $@

%.o: %.S
	@echo Building: $@
	@$(GCCPREFIX)-as $< -o $@

hexdump: $(infile)
	@od -t x1 $(infile) | sed -e "s/[0-9a-fA-F]\{7,9\}//" -e "s/ \([0-9a-fA-F][0-9a-fA-F]\)/0x\1, /g" >> $(outfile)

dreamcast/sound/snd_stream_drv.h: dreamcast/sound/snd_stream_drv.bin
	@echo "unsigned char aica_fw[] = {" >> $@
	@make hexdump -e infile=$< -e outfile=$@
	@echo "};\n" >> $@

common/exports/kernel_exports.o:
	@echo SKIPPING!: $@
#	@echo Building: $@
#	@$(GCCPREFIX)-gcc $(CFLAGS) -c $< -o $@

dreamcast/sound/snd_stream_drv.bin:
	@echo Building ARM sound driver...
	@make -C dreamcast/sound/arm -e PLATFORM=$(PLATFORM)
	@make -C dreamcast/sound/arm install
	@make -C dreamcast/sound/arm clean

dreamcast/sound/snd_stream_drv.o: dreamcast/sound/snd_stream_drv.bin
	@echo "Transforming... $< to $@"
	@echo ".section .rodata; .align 2; " | $(GCCPREFIX)-as -o tmp3.bin
	@echo "SECTIONS { .rodata : { _snd_stream_drv = .; *(.data); _snd_stream_drv_end = .; } }" > tmp1.ld
	@$(GCCPREFIX)-ld --no-warn-mismatch --format binary --oformat elf32-shl $< --format elf32-shl tmp3.bin -o tmp2.bin -r -EL -T tmp1.ld
	@$(GCCPREFIX)-objcopy --set-section-flags .rodata=alloc,load,data,readonly tmp2.bin $@
	@rm -f tmp1.ld tmp2.bin tmp3.bin $<

dreamcast/kernel/banner.o: dreamcast/kernel/banner.c
	@echo Generating banner data...
	$(eval VERSION:=Git revision $(shell git rev-list --full-history --all --abbrev-commit | head -1))
	$(eval HOSTNAME:=$(shell hostname -f))
	$(eval BANNER:="KallistiOS $(VERSION): $(shell date)\n  $(shell whoami)@$(HOSTNAME)")
	$(eval LICENSE:="$(shell cat LICENSE):")
	$(eval AUTHORS:="$(shell cat AUTHORS)")
	@echo Building: $@
	@$(GCCPREFIX)-gcc $(CFLAGS) -DBANNER=$(BANNER) -DLICENSE=$(LICENSE) -DAUTHORS=$(AUTHORS) -c $< -o $@

