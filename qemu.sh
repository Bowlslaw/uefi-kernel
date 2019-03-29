make
mkdir -p bootdrv/EFI/BOOT/
cp kernel.efi bootdrv/EFI/BOOT/BOOTX64.EFI
qemu-system-x86_64 -bios OVMF.fd -net none -drive file=fat:rw:bootdrv,format=raw
