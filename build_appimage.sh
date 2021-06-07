#!/bin/sh

if [ -d "AppDir" ] 
then
    rm -r AppDir
fi
if [ -d "Icons" ] 
then
    rm -r Icons
fi
if [ ! -d "out" ] 
then
    mkdir out
fi

## Download linuxdeploy

wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

./linuxdeploy-x86_64.AppImage --appdir AppDir -d Resources/com.smath.smathstudio.desktop
./linuxdeploy-x86_64.AppImage --appdir AppDir -e /usr/bin/mono
./linuxdeploy-x86_64.AppImage --appdir AppDir -l /usr/lib/libgdiplus.so
./linuxdeploy-x86_64.AppImage --appdir AppDir -l /usr/lib/libmono-btls-shared.so
./linuxdeploy-x86_64.AppImage --appdir AppDir -l /usr/lib/libmono-native.so
./linuxdeploy-x86_64.AppImage --appdir AppDir -l /usr/lib/libMonoPosixHelper.so

## Create all needed extra folders in the AppDir (not created by linuxdeploy)

mkdir -p AppDir/usr/lib/smath
mkdir -p AppDir/usr/lib/mono/4.5
mkdir -p AppDir/etc/mono/4.5

## Download SMath Release from SMath website and place the files in AppDir

wget --referer https://smath.com https://smath.com/file/oVRx7/SMathStudioDesktop.0_99_7822.Mono.tar.gz
VERSION=$(ls SMathStudioDesktop.* | head -1 | awk -F"." '{print $2}')
echo $VERSION > AppDir/VERSION
( cd AppDir/usr/lib/smath ; tar -zxvf ../../../../SMathStudio*.tar.gz)

## Download Icons from SMath website and rename/place them at correct locations in AppDir

wget --referer https://smath.com https://smath.com/file/YsSTE/SMathStudio.Icons.zip
unzip SMathStudio.Icons.zip -d Icons
cp Icons/SSLogo16.png AppDir/usr/share/icons/hicolor/16x16/smath.png
cp Icons/SSLogo32.png AppDir/usr/share/icons/hicolor/32x32/smath.png
cp Icons/SSLogo48.png AppDir/usr/share/icons/hicolor/48x48/smath.png
cp Icons/SSLogo64.png AppDir/usr/share/icons/hicolor/64x64/smath.png
cp Icons/SSLogo128.png AppDir/usr/share/icons/hicolor/128x128/smath.png
cp Icons/SSLogo256.png AppDir/usr/share/icons/hicolor/256x256/smath.png
cp Icons/SSLogo256.png AppDir/smath.png

## Copy files from git-repo/Resources to AppDir

cp Resources/com.smath.smathstudio.appdata.xml AppDir/usr/share/metainfo/
cp Resources/smathstudio.xml AppDir/usr/share/mime/packages/
cp Resources/smath_launcher AppDir/usr/bin/
cp Resources/restore-environment.sh AppDir/usr/bin/

chmod +x AppDir/usr/bin/smath_launcher
chmod +x AppDir/usr/bin/restore-environment.sh

## Copy libraries from host system (Github Actions Runner or local system) to AppDir

cp /etc/mono/config AppDir/etc/mono/
cp /etc/mono/4.5/machine.config AppDir/etc/mono/4.5
cp /usr/lib/mono/4.5/cert-sync.exe AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/mscorlib.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/Accessibility.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/Mono.Posix.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/Mono.Security.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.Configuration.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.Core.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.Data.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.Design.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.Drawing.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.Numerics.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.Security.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.Windows.Forms.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.Windows.Forms.DataVisualization.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/System.Xml.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/Microsoft.CSharp.dll AppDir/usr/lib/mono/4.5
cp /usr/lib/mono/4.5/Microsoft.VisualBasic.dll AppDir/usr/lib/mono/4.5

ARCH=x86_64
GLIBC=$(ldd --version | head -1 | awk '{print $5}')
ARCH=${ARCH} ./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage 

mv SMath*.AppImage out/SMathStudioDesktop.${VERSION}.${ARCH}.glibc${GLIBC}.AppImage

rm -f *.zip
rm -f *.tar.gz
rm -f *.AppImage
