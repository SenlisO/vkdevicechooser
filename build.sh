#!/bin/bash
VERSION=$(cat DEBIAN/control | grep 'Version: ' | sed 's/Version: //g')
PAK=$(cat DEBIAN/control | grep 'Package: ' | sed 's/Package: //g')
ARCH=$(cat DEBIAN/control | grep 'Architecture: '| sed 's/Architecture: //g')
FOLDER="$PAK\_$VERSION\_$ARCH"
FOLDER=$(echo "$FOLDER" | sed 's/\\//g')
OPTIONS="$1"
mkdir ../"$FOLDER"
##############################################################
#							     #
#							     #
#  COMPILE ANYTHING NECSSARY HERE			     #
#							     #
#							     #
##############################################################

set -eE
meson builddir --prefix=$PWD/usr
meson compile -C builddir
meson install -C builddir
set +eE

mkdir -p usr/share/man/man1
cp vkdevicechooser.1 usr/share/man/man1/
##############################################################
#							     #
#							     #
#  REMEMBER TO DELETE SOURCE FILES FROM TMP		     #
#  FOLDER BEFORE BUILD					     #
#							     #
#							     #
##############################################################
mkdir -p usr/share/doc/$PAK
git log > usr/share/doc/$PAK/changelog
cd usr/share/doc/$PAK
tar --verbose --create --xz -f changelog.gz changelog 1>/dev/null
rm changelog
cd ../../../..
if [ -d bin ]; then
	cp -R bin ../"$FOLDER"/bin
fi
if [ -d etc ]; then
	cp -R etc ../"$FOLDER"/etc
fi
if [ -d usr ]; then
	cp -R usr ../"$FOLDER"/usr
fi
if [ -d lib ]; then
	cp -R lib ../"$FOLDER"/lib
fi
if [ -d lib32 ]; then
	cp -R lib32 ../"$FOLDER"/lib32
fi
if [ -d lib64 ]; then
	cp -R lib64 ../"$FOLDER"/lib64
fi
if [ -d libx32 ]; then
	cp -R libx32 ../"$FOLDER"/libx32
fi
if [ -d sbin ]; then
	cp -R sbin ../"$FOLDER"/sbin
fi
if [ -d opt ]; then
	cp -R opt ../"$FOLDER"/opt
fi
cp -R DEBIAN ../"$FOLDER"/DEBIAN
base="$PWD"
cd ..
#DELETE STUFF HERE
rm -rfv "$base"/usr
if [ -d "$base"/builddir ]; then
	rm -rfv "$base"/builddir
fi
#build the shit
dpkg-deb --build "$FOLDER"
rm -rf "$FOLDER"
