# Xiaomi 12 (cupid) LineageOS Kernel with KernelSU-Next

Pre-built kernel and one-step boot image patcher for the Xiaomi 12 (codename: cupid, Qualcomm Snapdragon 8 Gen 1 / SM8450) running LineageOS 24 (Android 17, SDK 37).

---

## Requirements

* Device: Xiaomi 12 (cupid) with an unlocked bootloader.
* Operating System: LineageOS 24.0 (or ROMs directly sharing the LineageOS device tree, such as crDroid).
* Computer: Linux system with `bash` and `fastboot` installed.

---

## Option 1: Flash the Ready-to-Use Boot Image

If you are using the build `lineage-24.0-20261011-nightly-cupid-signed.zip`:

1. Download the pre-built boot image from the [Releases](https://github.com/joaovti/xiaomi-12-lineageos-ksunext/releases) page:
   * Compressed Archive (20 MB): `boot_ksu_next_v3.4.1_waipio.img.zip`
   * Raw Image (192 MB): `boot_ksu_next_v3.4.1_waipio.img`

2. Reboot your device to bootloader mode:
   ```bash
   adb reboot bootloader
   ```

3. Flash the boot image:
   ```bash
   fastboot flash boot boot_ksu_next_v3.4.1_waipio.img
   ```

4. Reboot:
   ```bash
   fastboot reboot
   ```

5. Install the KernelSU-Next manager application (v3.4.1 or newer).

---

## Option 2: Patch Any Official LineageOS Boot Image

When a new LineageOS update is released, you can patch its official `boot.img` directly without recompiling the kernel source code:

1. Download the official `boot.img` directly from the official LineageOS download portal for cupid (or extract `boot.img` from the signed update zip).

2. Clone this repository:
   ```bash
   git clone https://github.com/joaovti/xiaomi-12-lineageos-ksunext.git
   cd xiaomi-12-lineageos-ksunext
   ```

3. Run the patcher script with your official `boot.img`:
   ```bash
   ./patch_boot.sh boot.img
   ```

   The script automatically:
   * Unpacks the official boot image preserving its exact Android 17 ramdisk and VBMETA headers.
   * Injects the pre-compiled KernelSU-Next v3.4.1 kernel (`bin/Image`).
   * Repacks into `boot_ksunext_patched.img`.

4. Flash the patched boot image to your device:
   ```bash
   adb reboot bootloader
   fastboot flash boot boot_ksunext_patched.img
   fastboot reboot
   ```

---

## Technical Details

* Kernel Version: Linux 5.10.269-gki (Qualcomm SM8450 Waipio)
* Root Solution: KernelSU-Next v3.4.1 (Build 33333)
* Compiler: Clang 22.1.8 with lld (LLVM 1) matching LineageOS 24 vendor module ABI
* Companion Module: Fully compatible with the [Xiaomi 12 Thermal & Performance Manager](https://github.com/joaovti/xiaomi-12-thermal-perf-manager)

---

## License

The Linux kernel is licensed under GPL-2.0. KernelSU-Next is licensed under GPL-3.0.
Scripts and tooling in this repository are released under MIT.
