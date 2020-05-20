#!/bin/bash -euo

chmod +x bin/*
mkdir -p $PREFIX/bin
mv bin/* $PREFIX/bin/
ls -la $PREFIX/bin

mkdir -p $PREFIX/include
mv include/* $PREFIX/include
if [ -e ./jre/lib/jspawnhelper ]; then
    chmod +x ./jre/lib/jspawnhelper
fi

if [[ ${target_platform} == linux-ppc64le ]]; then
   ARCH=ppc64le
fi

if [[ ${target_platform} == linux-aarch64 ]]; then
   ARCH=aarch64
fi

if [[ `uname` == "Linux" ]]
then
    mv lib/$ARCH/jli/*.so lib
    mv lib/$ARCH/*.so lib
    rm -r lib/$ARCH
    # libnio.so does not find this within jre/lib/amd64 subdirectory
    cp jre/lib/$ARCH/libnet.so lib
    # libjvm.so isn't found
    cp jre/lib/$ARCH/server/libjvm.so lib

    # Include dejavu fonts to allow java to work even on minimal cloud
    # images where these fonts are missing (thanks to @chapmanb)
    mkdir -p lib/fonts
    mv ./fonts/ttf/* ./lib/fonts/
    rm -rf ./fonts
fi

mkdir -p $PREFIX/jre
mv jre/* $PREFIX/jre

mkdir -p $PREFIX/lib
mv lib/* $PREFIX/lib

mkdir -p $PREFIX/man
mv man/* $PREFIX/man

mv src.zip $PREFIX/src.zip

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
