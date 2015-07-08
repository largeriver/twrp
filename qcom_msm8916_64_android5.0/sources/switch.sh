#!/bin/sh 
set -o errexit

# set defaults
BRANCH="twrp"
AOSP_TOPDIR="$HOME/Work/tmp/COSHIP_X1_5_0_FDH"


usage() {
cat <<USAGE

Usage:
    bash $0 <BRANCH> [OPTIONS]
	
	OPTIONS:
    -d, --dst <AOSP_TOPDIR>
        specify the AOSP_TOPDIR to compile (default:$AOSP_TOPDIR)

    -h, --help
        Display this help message
USAGE
}	

# Setup getopt.
long_opts="help,dst:"
getopt_cmd=$(getopt -o hd: --long "$long_opts" \
            -n $(basename $0) -- "$@") || \
            { echo -e "\nERROR: Getopt failed. Extra args\n"; usage; exit 1;}

eval set -- "$getopt_cmd"

while true; do
    case "$1" in
		-h|--help) usage; exit 0;;
        -d|--dst) AOSP_TOPDIR="$2";;
        --) shift; break;;
    esac
    shift
done


if [ $# -gt 1 ]; then
	usage
	exit 1
fi

if [ $# -eq 1 ]; then
	BRANCH="$1";shift
fi

# check dirs
if [ ! -d "$BRANCH" ]; then  
	echo -e "ERROR:$BRANCH is not exist\n"
	exit 1
fi  

if [ ! -d "$AOSP_TOPDIR" ]; then  
	echo -e "ERROR:$AOSP_TOPDIR is not exist\n"
	exit 1
fi  

echo "switch branch to $BRANCH under $AOSP_TOPDIR"
 
rm -fr $AOSP_TOPDIR/bootable/recovery
rm -fr $AOSP_TOPDIR/device/qcom/msm8916_64

cp -f $BRANCH/build/core/Makefile $AOSP_TOPDIR/build/core/ 
cp -fr $BRANCH/bootable/recovery $AOSP_TOPDIR/bootable/
cp -fr $BRANCH/device/qcom/msm8916_64 $AOSP_TOPDIR/device/qcom/

echo "switch finished!!!"
