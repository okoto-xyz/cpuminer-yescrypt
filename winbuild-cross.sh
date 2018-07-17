#!/bin/bash

#CURLVER=7.61.0
#tar xzf curl-$CURLVER.tar.gz
#ln -s curl-$CURLVER curl
#cd curl
#./configure --with-winssl --with-winidn --host=i686-w64-mingw32
#make -j4

#LOCAL_LIB=`pwd`

export LDFLAGS="-Lcurl/lib/.libs"

#F="--with-libcurl=curl --host=i686-w64-mingw32"
F="--with-libcurl=curl --host=x86_64-w64-mingw32"
#CFLAGS="-DWIN32 -DPTW32_STATIC_LIB -O3 -fomit-frame-pointer"
CFLAGS="-Wall -O3 -fomit-frame-pointer"

mkdir release
cp README.txt release/
#cp /usr/i686-w64-mingw32/lib/libwinpthread-1.dll release/
cp /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll release/
cp curl/lib/.libs/libcurl-4.dll release/

make distclean || echo clean
rm -f config.status
./autogen.sh || echo done
CFLAGS="$CFLAGS -march=core-avx2 -msha" ./configure $F
make -j4
strip -s minerd.exe
mv minerd.exe release/minerd-avx2-sha.exe

make clean || echo clean
rm -f config.status
CFLAGS="$CFLAGS -march=core-avx2" ./configure $F 
make -j4
strip -s minerd.exe
mv minerd.exe release/minerd-avx2.exe

make clean || echo clean
rm -f config.status
CFLAGS="$CFLAGS -march=corei7-avx" ./configure $F 
make -j4
strip -s minerd.exe
mv minerd.exe release/minerd-avx.exe

# -march=westmere is supported in gcc5
make clean || echo clean
rm -f config.status
CFLAGS="$CFLAGS -march=westmere" ./configure $F
#CFLAGS="$CFLAGS -maes -msse4.2" ./configure $F
make -j4
strip -s minerd.exe
mv minerd.exe release/minerd-aes-sse42.exe

make clean || echo clean
rm -f config.status
CFLAGS="$CFLAGS -msse2" ./configure $F
make -j4
strip -s minerd.exe
mv minerd.exe release/minerd-sse2.exe
make clean || echo clean

