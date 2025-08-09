# bluefin-x - My personal Bluefin customizations

[Bluefin](https://github.com/ublue-os/bluefin) customizations for my personal
use. I highly recommend that you **do not use these images for your own use**.
Create your own using the [ublue image-template](https://github.com/ublue-os/image-template)
which has good documentation and can be customized however you need it. This
project is for my personal use.

## Image Variants

This repository builds two image variants:

1. **Standard** (`bluefin-x`) - Based on `ghcr.io/ublue-os/bluefin-dx:gts`
2. **NVIDIA** (`bluefin-x-nvidia`) - Based on
   `ghcr.io/ublue-os/bluefin-dx-nvidia:gts` with optimized NVIDIA driver support

## Custom Components

All image variants extend Bluefin with the same customizations. See the
[build_files/build.sh](build_files/build.sh) script for the exact changes.

## How to Use

Use the `bluefin-x` image for most systems. Use `bluefin-x-nvidia` for systems
with NVIDIA graphics hardware.

These instructions assume that you're already using a bootc system. This would
mean something like installing the mainline bluefin image first and then
following these instructions. Alternatively, finish the disk image building
workflow documented at [the official image-template
repository](https://github.com/ublue-os/image-template).

### Switching to this Image

When on a bootc system, switch to your preferred image variant by running:

```bash
# For standard systems
sudo bootc switch ghcr.io/kevinconway/bluefin-x

# For systems with NVIDIA graphics
sudo bootc switch ghcr.io/kevinconway/bluefin-x-nvidia
```

After rebooting, you'll be running this customized image.

### Updating the Image

The bluefin integrated auto-update features should pull in updates for you.

If you need to update manually, you can switch to the latest version using the
same command:

```bash
# For standard systems
sudo bootc switch ghcr.io/kevinconway/bluefin-x

# For systems with NVIDIA graphics
sudo bootc switch ghcr.io/kevinconway/bluefin-x-nvidia
```

And reboot to apply the updates.

## Repository Structure

- **Standard Image:**
  - `Containerfile` - Configuration file for the standard image
  - `.github/workflows/build.yml` - GitHub Actions workflow for building the
    standard image
  - `.github/workflows/build-disk.yml` - GitHub Actions workflow for building
    disk images

- **NVIDIA Variant:**
  - `Containerfile.nvidia` - Configuration file for the NVIDIA-enabled image
  - `.github/workflows/build-nvidia.yml` - GitHub Actions workflow for building
    the NVIDIA image
  - `.github/workflows/build-disk-nvidia.yml` - GitHub Actions workflow for
    building NVIDIA disk images

- **Shared Components:**
  - `build_files/build.sh` - Script that runs during build to customize both
    image variants
  - `Justfile` - Contains utility commands for building and testing locally
  - `disk_config/` - Configuration for disk image generation

## Making Changes

1. Modify `build_files/build.sh` to add or remove packages (affects both
   variants)
2. For variant-specific changes, edit the appropriate Containerfile
3. Commit changes to GitHub repository
4. GitHub Actions will automatically build both image variants
5. Switch to the new image as described above

## Local Testing

Use the Justfile commands for local testing:

```bash
# Build the standard image locally
just build

# Build and test in a virtual machine (standard variant)
just build-qcow2
just run-vm-qcow2
```

## Package Version Updates

Some extra packages may need periodic maintenance. See the
`build_files/build.sh` script for details.
