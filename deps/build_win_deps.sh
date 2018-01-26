#!/bin/bash
set -e
PREFIX=${PWD}/x86_64-w64-mingw32

CURL_PACKAGE=curl-7.54.1
CURL_PACKAGE_FILE=${CURL_PACKAGE}.tar.gz
CURL_PACKAGE_FILE_SHA256=cd404b808b253512dafec4fed0fb2cc98370d818a7991826c3021984fc27f9d0
CURL_CHECKSUM_FILE=${CURL_PACKAGE_FILE}.sha256

wget https://curl.haxx.se/download/$CURL_PACKAGE_FILE -O $CURL_PACKAGE_FILE
echo "${CURL_PACKAGE_FILE_SHA256}  ${CURL_PACKAGE_FILE}" > $CURL_CHECKSUM_FILE
sha256sum -c $CURL_CHECKSUM_FILE
rm $CURL_CHECKSUM_FILE

rm -rf pthread-win32
git clone https://github.com/GerHobbelt/pthread-win32.git

tar zxvf $CURL_PACKAGE_FILE

cd $CURL_PACKAGE
./configure --host=x86_64-w64-mingw32 --disable-shared --enable-static --with-winssl --prefix=$PREFIX
make install

cd ../pthread-win32/
cp config.h pthreads_win32_config.h
make -f GNUmakefile CROSS="x86_64-w64-mingw32-" clean GC-static
cp libpthreadGC2.a ${PREFIX}/lib/libpthread.a
cp pthread.h semaphore.h sched.h ${PREFIX}/include
