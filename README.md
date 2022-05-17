#### About:

This script will do the following:

*   Download and install Waterfox version G3.2.6
*   Disable automatic updates for Waterfox as any update will break Flash support
*   Download and install PPAPI Flash Plug-Ins version 34.0.0.242

---

#### A couple of notes before you get started:

*   This script will only work on MacOS.
*   The script will ask for your password as some actions require elevated privileges.

---

#### Usage:

1 - Open a terminal

2 - Create a folder and access it

```plaintext
mkdir ~/flashbundleinstaller && cd ~/flashbundleinstaller
```

3 - Download the script

```plaintext
curl -o installer.sh https://raw.githubusercontent.com/MadScripter/FlashBundleInstaller/main/installer.sh
```

4 - Make the script executable

```plaintext
chmod +x installer.sh
```

5 - Run the script

```plaintext
./installer.sh
```

---

Tested on MacOS Big Sur 11.2.3