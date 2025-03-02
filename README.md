# tf2mapfix
A shell script to fix broken community maps on TF2 Linux.
If a community map is missing a bunch of textures or other resources, this script will *probably* fix it.

This script will take map files from your TF2 downloads, decompile them with VPKEdit, and put the unpacked files into your TF2 custom directory for you.

# Installation
First download the Linux VPKEdit CLI from [here](https://github.com/craftablescience/VPKEdit/releases/download/v4.4.1/VPKEdit-Linux-Standalone-CLI-gcc-Release.zip)

Extract the zip to whatever destination you want to have it.
Next, download tf2mapfix.sh and put it the VPKEditCLI directory you created.

# Running the script
Make sure tf2mapfix.sh has execute permissions and run the sh file in the terminal from your VPKEdit directory.

To run this script on all map files:
```
./tf2mapfix.sh
```

To run this script on specific map files:
```
./tf2mapfix.sh -f
./tf2mapfix.sh --files      #the script will prompt you for what files you want to use
```

The script will first look for your TF2 directory in its default location, and if it is not found, will prompt the user to input their installation directory. This location will be saved in a config file for later use.

# Possible Issues

There will likely be some sort of bug from a use case I haven't be able to test. Feel free to contact me @ thebeandev@gmail.com, or try to fix these yourself.
