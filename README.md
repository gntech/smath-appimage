## Automatic generation of AppImages for SMath Studio https://smath.com

SMath Studio AppImages are available from the Releases page https://github.com/gntech/smath-appimage/releases

## How it works

This is made to run on Github Actions but it is also possible to run locally for debug purposes.

The Github action to build the AppImage is run on each push to this repository. See `.github/workflows/build-appimage.yml` The built AppImage can be found under the "Actions" tab.

To run the script locally for *debugging or development* do the following.

``` bash
# Install needed mono libraries
sudo apt install libmono-system-windows-forms4.0-cil libmono-microsoft-visualbasic10.0-cil libmono-system-windows-forms-datavisualization4.0a-cil

./build_appimage.sh
```

Locally built AppImage will be in the "out" directory.

## Aknowledgements

The structure of this appimage is based on studying the appimage-work by overlord on the SMath forum as well as the OpenRA appimage
