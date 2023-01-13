# Vulkan Device Chooser Layer

This is a quick and dirty implementation of a Vulkan layer to force a specific physical device to be used. This is useful for Vulkan games which do not provide an option to choose the device themselves.

KaseyTheJackal patched it to work on Fedora. Fedora's `vk_layer_dispatch_table.h` wasn't in the expected folder.

Compiling requires `vulkan/vulkan.h`, `vulkan/vk_layer.h` and `vulkan/vulkan/vk_layer_dispatch_table.h`.
You can install these with:
```bash
sudo apt install libvulkan-dev vulkan-validationlayers-dev
```

Build and install with:
```bash
meson builddir --prefix=/usr
meson compile -C builddir
sudo meson install -C builddir
```

This will install to the system's Vulkan layer directory, `/usr/share/vulkan/implicit_layer.d/`.

To run a Vulkan application forcing a specific device to be used, launch it with these environment variables:
```
ENABLE_DEVICE_CHOOSER_LAYER=1 VULKAN_DEVICE_INDEX=<device index>
```
Replace `<device index>` with the "GPU id" for the desired device as reported by `vulkaninfo` (without the layer enabled).

For example:
```bash
$ ENABLE_DEVICE_CHOOSER_LAYER=1 VULKAN_DEVICE_INDEX=1 vulkaninfo
```
should give info for the device which had GPU id 1 when running `vulkaninfo` without the environment variable set.

The layer can be used with Steam games by setting their launch options to:
```
ENABLE_DEVICE_CHOOSER_LAYER=1 VULKAN_DEVICE_INDEX=<device index> %command%
```
