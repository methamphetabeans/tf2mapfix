# tf2mapfix
A shell script to fix broken maps on TF2 Linux

This script is intended to fix custom maps that have broken textures (and other missing resources)

This script will take every map from your TF2 downloads, decompile it with VPKEdit, and put the unpacked files into your TF2 custom directory for you.

By default, every map will be processed. I (might) add a feature later that allows you to specify individual maps to process.

# Installation
First download the Linux VPKEdit CLI from [here](https://github.com/craftablescience/VPKEdit/releases/download/v4.4.1/VPKEdit-Linux-Standalone-CLI-gcc-Release.zip)

Extract the zip to whatever destination you want to have it.
Next, download tf2mapfix.sh and put it the VPKEditCLI directory you created.

# Running the script
Make sure tf2mapfix.sh has execute permissions and run the sh file in the terminal from your VPKEdit directory:
```
./tf2mapfix.sh
```

The script will first look for your TF2 directory in its default location, and if it is not found, will prompt the user to input their installation directory. This location will be saved in a config file for later use.

# Possible Issues

There will likely be some sort of bug from a use case I haven't be able to test. Feel free to contact me @ thebeandev@gmail.com or try to fix these yourself.
