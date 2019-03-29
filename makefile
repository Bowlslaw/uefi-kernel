ARCH			= $(shell uname -m | sed s,i[3456789]86,ia32,)

SRCS			= kernel.asm
TARGET			= $(SRCS:%.asm=%.efi)
LIBS			= $(SRCS:%.asm=%.lib)
OBJS			= $(SRCS:%.asm=%.obj)

AS				= nasm
ASFLAGS			= -fwin64

CC				= clang
CFLAGS			= --target x86_64-unknown-windows -ffreestanding \
				  -fshort-wchar -mno-red-zone

LD				= lld-link-7
LDFLAGS			= -subsystem:efi_application -nodefaultlib -dll \
				  -entry:_start

kernel.efi: kernel.obj
		$(LD) $(LDFLAGS) $(OBJS) -out:$@

kernel.obj:
		$(AS) $(ASFLAGS) $(SRCS)

.PHONY: all clean

all: kernel.efi

clean:
		rm -rf bootdrv
		rm -f $(OBJS) $(TARGET) $(LIBS)

#qemu-system-x86_64 -bios OVMF.fd -net none -drive file=fat:rw:bootdrv,format=raw

#clang -I/usr/include/efi -I/usr/include/efi/x86_64 -I /usr/include/efi/protocol -fno-stack-protector -fpic -fshort-wchar -mno-red-zone -DHAve_USE_MS_ABI -c -o main2.o main2.c

#lld-link-7 -subsystem:efi_application -nodefaultlib -dll -entry:_start kernel.obj -out:kernel.efi

#nasm -f win64 kernel.asm
