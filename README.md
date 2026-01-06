# Kernel Firmware Non-Free Installer GUI
A lightweight graphical installer/uninstaller for the kernel-firmware-nonfree package on Mageia-based systems.

This tool allows users to explicitly install or remove the large non-free firmware bundle only when it is actually needed, helping to keep live systems and minimal installations lightweight.

This application provides a simple and transparent way to manage the kernel-firmware-nonfree package.

By default, many live or portable systems avoid installing this package due to its size (~1,5 GB installed) and the fact that most common hardware is already supported by smaller firmware packages (Intel / Realtek Wi-Fi, etc.).

Instead of shipping the full firmware set by default, this GUI offers a single, explicit action to install or remove the package on an already installed system.

**Design philosophy**
+ No automatic hardware detection
+ No background actions
+ No hidden dependencies

The user explicitly decides whether the full non-free firmware bundle is required.
