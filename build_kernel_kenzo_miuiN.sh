#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/WORKING_DIRECTORY/AGNi_stamp.sh
. ~/WORKING_DIRECTORY/gcc-8.x-uber_aarch64.sh

echo ""
echo " Cross-compiling AGNi pureMIUI-N kernel ..."
echo ""

cd $KERNELDIR/

if [ ! -f $KERNELDIR/.config ];
then
    make agni_kenzo-miuiN_defconfig
fi

rm $KERNELDIR/arch/arm/boot/dts/*.dtb
rm $KERNELDIR/drivers/staging/prima/wlan.ko
rm $KERNELDIR/include/generated/compile.h
if [ "`grep "AGNI_OREO_SYSMOUNT_MARKER" $KERNELDIR/arch/arm/boot/dts/qcom/kenzo/msm8956-kenzo.dtsi`" ];
	then
	if [ -f $KERNELDIR/arch/arm/boot/dts/qcom/kenzo/msm8956-kenzo.dtsi.bak ];
		then
		rm $KERNELDIR/arch/arm/boot/dts/qcom/kenzo/msm8956-kenzo.dtsi.bak
	fi
	cp -f $KERNELDIR/arch/arm/boot/dts/qcom/kenzo/msm8956-kenzo.dtsi $KERNELDIR/arch/arm/boot/dts/qcom/kenzo/msm8956-kenzo.dtsi.bak
	sed -i '/AGNI_OREO_SYSMOUNT_MARKER/d' $KERNELDIR/arch/arm/boot/dts/qcom/kenzo/msm8956-kenzo.dtsi
fi
make -j4 || exit 1
rm $KERNELDIR/arch/arm/boot/dts/qcom/kenzo/msm8956-kenzo.dtsi
mv $KERNELDIR/arch/arm/boot/dts/qcom/kenzo/msm8956-kenzo.dtsi.bak $KERNELDIR/arch/arm/boot/dts/qcom/kenzo/msm8956-kenzo.dtsi

rm -rf $KERNELDIR/BUILT_kenzo-miuiN
mkdir -p $KERNELDIR/BUILT_kenzo-miuiN/
#mkdir -p $KERNELDIR/BUILT_kenzo-miuiN/system/lib/modules/pronto

find -name '*.ko' -exec mv -v {} $KERNELDIR/BUILT_kenzo-miuiN/ \;

mv $KERNELDIR/arch/arm64/boot/Image.*-dtb $KERNELDIR/BUILT_kenzo-miuiN/

echo ""
echo "AGNi pureMIUI-N has been built for kenzo !!!"

