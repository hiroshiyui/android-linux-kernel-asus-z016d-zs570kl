# Building the Kernel for ASUS Zenfone 3 Deluxe (Z016D/ZS570KL)

## 1. Setup Build Environment

Use the provided `Dockerfile` to set up a consistent build environment with Podman.

```bash
podman build -t z016d-build .
podman run -it -v "$(pwd)":/build z016d-build /bin/bash
```

## 2. Build the Kernel

First, set the required environment variables. Then, configure and build the kernel. Using `-j$(nproc)` will speed up compilation by using all available CPU cores.

```bash
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make zs570kl_defconfig
make -j$(nproc)
```

## 3. Repack the `boot.img`

These steps use Magisk tools to inject the newly built kernel into a stock `boot.img`.

1.  Download the Magisk APK from its official repository and extract its contents (it's a standard Zip archive).
2.  Navigate to the `lib/x86_64/` directory and rename `libmagiskboot.so` to `magiskboot`.
3.  Make the `magiskboot` binary executable:
    ```bash
    chmod +x magiskboot
    ```
4.  Extract the stock `boot.img` from a factory ROM zip file (e.g., `UL-Z016-WW-15.0210.1810.73-user.zip`).
5.  Unpack the `boot.img`:
    ```bash
    ./magiskboot unpack boot.img
    ```
6.  Replace the original kernel `Image` with the one you just built.
    ```bash
    # Adjust the source path to your kernel source directory
    cp <path_to_kernel_source>/arch/arm64/boot/Image kernel
    ```
7.  Replace the original device tree blob (`dtb`) with the one you built.
    ```bash
    # Adjust the source path to your kernel source directory
    cp <path_to_kernel_source>/arch/arm64/boot/dts/qcom/msm8996-v3-pmi8996-mtp-zs570kl-SR1.dtb kernel_dtb
    ```
8.  Repack the boot image:
    ```bash
    ./magiskboot repack boot.img image-new.img
    ```

## 4. Boot the New Image

You can test the new boot image without permanently flashing it using `fastboot`.

1.  Reboot your device into the bootloader:
    ```bash
    adb reboot bootloader
    ```
2.  Temporarily boot with the new image:
    ```bash
    fastboot boot image-new.img
    ```
