#!/usr/bin/env bash
set -e

# Xiaomi 12 LineageOS 24 KernelSU-Next Boot Patcher
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAGISKBOOT="$SCRIPT_DIR/tools/magiskboot"
KERNEL_IMAGE="$SCRIPT_DIR/bin/Image"

INPUT_BOOT="$1"
OUTPUT_BOOT="${2:-$SCRIPT_DIR/boot_ksunext_patched.img}"

if [ -z "$INPUT_BOOT" ] || [ ! -f "$INPUT_BOOT" ]; then
    echo "Usage: ./patch_boot.sh <official_boot.img> [output_boot.img]"
    echo ""
    echo "Example: ./patch_boot.sh boot.img"
    exit 1
fi

if [ ! -f "$KERNEL_IMAGE" ]; then
    echo "Error: Kernel binary not found at: $KERNEL_IMAGE"
    exit 1
fi

chmod +x "$MAGISKBOOT"

WORK_DIR="$(mktemp -d -t cupid_patch_XXXXXX)"
echo "Unpacking official boot image..."
cd "$WORK_DIR"
"$MAGISKBOOT" unpack -h "$INPUT_BOOT"

echo "Injecting KernelSU-Next v3.4.1 kernel..."
cp -f "$KERNEL_IMAGE" ./kernel

echo "Repacking boot image preserving official ramdisk and headers..."
"$MAGISKBOOT" repack "$INPUT_BOOT" new-boot.img

mv -f new-boot.img "$OUTPUT_BOOT"
rm -rf "$WORK_DIR"

echo "===================================================="
echo " Boot image successfully patched with KernelSU-Next!"
echo " Output file: $OUTPUT_BOOT"
echo " Flash with:  fastboot flash boot $(basename "$OUTPUT_BOOT")"
echo "===================================================="
