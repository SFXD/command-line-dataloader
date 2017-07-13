#!/bin/sh
########################################################################################################################
########################################################################################################################
###########																									############
###########									Salesforce Dataloader											############
###########							Single-Load No-interaction Dataload script								############
###########									v. 1 @ Windyo													############
###########									Requires Dataloader.jar											############
###########																									############
###########																									############
########################################################################################################################
########################################################################################################################

#Set the variables for the script here.
#Standard bash filtering and variable expansion applies.
export DLPATH=""
export DLCONF=""
OPERATION="UPSERT"
DATATOLOAD=""
ARCHIVE="./archive"

function sanitycheck
{
    if [ -z "$DLPATH" ]
    then
        echo 'DLPATH is not set. Please set it in the script, this should normally not vary after first use. This should point to where dataloader-uber.jar is stored, in the format "/home/user/pathtojar"'
        exit
    else if [ -z "$DLCONF" ]
        echo 'DLCONF is not set. Please set it in the script, this should normally not vary after first use. This should point to where the config files for the dataloader are stored, in the format "/home/user/pathtoconfig"'
        exit
        else
        massload
    fi
}
#Run the Dataloader with set parameters.
function dataload {
java -cp "$DLPATH/*" -Dsalesforce.config.dir=$DLCONF com.salesforce.dataloader.process.ProcessRunner process.name=$OPERATION
mv $DATATOLOAD "$ARCHIVE"/"$OPERATION"_$(date +%F).csv
}

function usage
{
    echo "usage: dataload.sh [-a (OPERATION /yourpath/to/jar /yourpath/to/config /path/to/file.csv path/to/archive)] | [-h]]"
}


###ARGUMENTS
while [ "$1" != "" ]; do
    case $1 in
        -a | --automatic )      shift
                                AutomaticMode=1
                                OPERATION=$1
                                DLPATH=$2
                                DLCONF=$3
                                DATATOLOAD=$4
                                ARCHIVE=$5
                                sanitycheck
                                exit
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     exit 1
    esac
    shift
done

###MAIN
sanitycheck
