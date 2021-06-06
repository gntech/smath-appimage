#!/bin/sh

rm -f *.tar.gz
rm -f *.zip

if [ -d "AppDir" ] 
then
    rm -r AppDir
else
    echo "AppDir does not exists."
fi
if [ -d "Icons" ] 
then
    rm -r Icons
else
    echo "Icons does not exists."
fi
if [ -d "out" ] 
then
    echo "out exists."
else
    mkdir out
fi

## Create all needed folders in the AppDir

mkdir -p AppDir/etc/mono/4.5
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/mime/packages
mkdir -p AppDir/usr/share/icons/hicolor/16x16
mkdir -p AppDir/usr/share/icons/hicolor/32x32
mkdir -p AppDir/usr/share/icons/hicolor/48x48
mkdir -p AppDir/usr/share/icons/hicolor/64x64
mkdir -p AppDir/usr/share/icons/hicolor/128x128
mkdir -p AppDir/usr/share/icons/hicolor/256x256
mkdir -p AppDir/usr/share/icons/hicolor/512x512
mkdir -p AppDir/usr/share/icons/hicolor/1024x1024
mkdir -p AppDir/usr/share/icons/hicolor/scalable
mkdir -p AppDir/usr/lib/mono/4.5
mkdir -p AppDir/usr/lib/smath

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

## Copy files from git-repo to AppDir

cp AppRun AppDir/
cp smath.desktop AppDir/
cp smath.desktop AppDir/usr/share/applications/
cp smath_launcher AppDir/usr/bin/
cp restore-environment.sh AppDir/usr/bin/

chmod +x AppDir/usr/bin/smath_launcher
chmod +x AppDir/usr/bin/restore-environment.sh

## Copy libraries from host system (Github Actions Runner or local system) to AppDir

cp /usr/bin/mono AppDir/usr/bin
cp /etc/mono/config AppDir/etc/mono/
cp /etc/mono/4.5/machine.config AppDir/etc/mono/4.5

cp /usr/lib/libgdiplus.so.0 AppDir/usr/lib
cp /usr/lib/libmono-btls-shared.so AppDir/usr/lib
cp /usr/lib/libmono-native.so AppDir/usr/lib
cp /usr/lib/libMonoPosixHelper.so AppDir/usr/lib

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

## Download appimagetool and Build AppImage from AppDir

wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
ARCH=x86_64
GLIBC=$(ldd --version | head -1 | awk '{print $5}')
ARCH=${ARCH} ./appimagetool-x86_64.AppImage AppDir out/SMathStudioDesktop.${VERSION}.${ARCH}.glibc${GLIBC}.AppImage

rm -f *.zip
rm -f *.tar.gz
rm -f *.AppImage
