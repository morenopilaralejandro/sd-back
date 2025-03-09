#!/bin/bash
#variables
pathSaveData="/home/$USER/Documents/save-data/";
pathAn="/run/user/$UID/gvfs/mtp:host=Xiaomi_POCO_F3_ac85dfb1/Internal shared storage/"
ndsAn="Games/nds/nds-save/";
gbaAn="MyBoy/save/";
ps1An="Android/data/com.github.stenzek.duckstation/files/memcards/"
#configure ps2 memcard as folder
ps2An="Android/data/xyz.aethersx2.android/files/memcards/ps2-save.ps2/";

#methods
errorEcho() {
  echo "$@" 1>&2;
}

usage() {
    echo "Supported systems: nds, gba ps1 and ps2";
    echo "Options:";
    echo "  -u SYSTEM";
    echo "          upload save data from Android to PC";
    echo "";
    echo "  -d SYSTEM";
    echo "          download save data from PC to Android";
    echo "";
    echo "  -b SYSTEM";
    echo "          backup PC save data";
    echo "";
    echo "  -h";
    echo "          display help and exit";
    exit;
}

checkArgs() {
    local OPTIND;
    #if argument number != 1 then show usage
    if [ $# -eq 0 ]; then
        usage;
        exit;
    fi
}

isDirectory() {
    if [ -d "$@" ]; then
        return;
    fi
    false;
}

isFile() {
    if [ -f "$@" ]; then
        return;
    fi
    false;
}

confirmContinue() {
    read -p "Continue? (y/n)" choice
    case "$choice" in 
      y|Y ) 
        return;
        ;;
      n|N ) 
        false;
        ;;
      * ) 
        false;
        ;;
    esac
}

#fun-nds
ndsUpload() {
    echo "Downloading nds save data from PC to Android";
    if confirmContinue; then
        cp -rf "${pathAn}${ndsAn}"* "${pathSaveData}"nds-save/;
        echo "Done";
    else
        errorEcho "Aborted";
    fi

}
ndsDownload() {
    echo "Downloading nds save data from PC to Android";
    if confirmContinue; then
        cp -rf "${pathSaveData}"nds-save/* "${pathAn}${ndsAn}";
        echo "Done";
    else
        errorEcho "Aborted";
    fi
}
ndsBack() {
    echo "Creating backup for nds save data (PC)";
    fileName="nds-save-$(date +"%Y%m%d%H%M%S").tar";
    cd ${pathSaveData};
    tar -cf "${fileName}" "nds-save";  
    echo "Done";
}
#fun-gba
gbaUpload() {
    echo "Downloading gba save data from PC to Android";
    if confirmContinue; then
        cp -rf "${pathAn}${gbaAn}"* "${pathSaveData}"gba-save/;
        echo "Done";
    else
        errorEcho "Aborted";
    fi

}
gbaDownload() {
    echo "Downloading gba save data from PC to Android";
    if confirmContinue; then
        cp -rf "${pathSaveData}"gba-save/* "${pathAn}${gbaAn}";
        echo "Done";
    else
        errorEcho "Aborted";
    fi
}
gbaBack() {
    echo "Creating backup for gba save data (PC)";
    fileName="gba-save-$(date +"%Y%m%d%H%M%S").tar";
    cd ${pathSaveData};
    tar -cf "${fileName}" "gba-save";  
    echo "Done";
}
#fun-ps1
ps1Upload() {
    echo "Downloading ps1 save data from PC to Android";
    if confirmContinue; then
        cp -rf "${pathAn}${ps1An}"* "${pathSaveData}"ps1-save/;
        echo "Done";
    else
        errorEcho "Aborted";
    fi
}
ps1Download() {
    echo "Downloading ps1 save data from PC to Android";
    if confirmContinue; then
        cp -rf "${pathSaveData}"ps1-save/* "${pathAn}${ps1An}";
        echo "Done";
    else
        errorEcho "Aborted";
    fi
}
ps1Back() {
    echo "Creating backup for ps1 save data (PC)";
    fileName="ps1-save-$(date +"%Y%m%d%H%M%S").tar";
    cd ${pathSaveData};
    tar -cf "${fileName}" "ps1-save";  
    echo "Done";
}

#fun-ps2
ps2Upload() {
    echo "Downloading ps2 save data from PC to Android";
    if confirmContinue; then
        cp -rf "${pathAn}${ps2An}"* "${pathSaveData}"ps2-save.ps2/;
        echo "Done";
    else
        errorEcho "Aborted";
    fi
}
ps2Download() {
    echo "Downloading ps2 save data from PC to Android";
    if confirmContinue; then
        cp -rf "${pathSaveData}"ps2-save.ps2/* "${pathAn}${ps2An}";
        echo "Done";
    else
        errorEcho "Aborted";
    fi
}
ps2Back() {
    echo "Creating backup for ps2 save data (PC)";
    fileName="ps2-save-$(date +"%Y%m%d%H%M%S").tar";
    cd ${pathSaveData};
    tar -cf "${fileName}" "ps2-save.ps2";  
    echo "Done";
}

handleFlags() {
    local OPTIND;
    while getopts "u:d:b:h" flag; do
        case "${flag}" in
            u)  #Upload save data from Android to PC
                case "${OPTARG}" in
                    nds) 
                        ndsUpload;
                        ;;
                    gba) 
                        gbaUpload;
                        ;;
                    ps1) 
                        ps1Upload;
                        ;;
                    ps2) 
                        ps2Upload;
                        ;;
                esac
                ;;
            d)  #Download save data from PC to Android
                case "${OPTARG}" in
                    nds) 
                        ndsDownload;
                        ;;
                    gba) 
                        gbaDownload;
                        ;;
                    ps1) 
                        ps1Download;
                        ;;
                    ps2) 
                        ps2Download;
                        ;;
                esac
                ;;
            b)  #Backup PC save data
                case "${OPTARG}" in
                    nds) 
                        ndsBack;
                        ;;
                    gba) 
                        gbaBack;
                        ;;
                    ps1) 
                        ps1Back;
                        ;;
                    ps2) 
                        ps2Back;
                        ;;
                esac
                ;;
            h)  #help
                usage;
                ;;
            \?) #invalid option
                usage;
                ;;
            *) #invalid option
                usage;
                ;;
        esac
    done
}

main() {
    local OPTIND;
    checkArgs "$@";
    handleFlags "$@";
}

main "$@";
