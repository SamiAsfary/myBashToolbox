#This script extract all logs sorted by identifier
#
#journalctl --field=SYSLOG_IDENTIFIER

srcOption="-t"
srcField="SYSLOG_IDENTIFIER"
needCompressing=false
tarCompressing=false
zipCompressing=false
tgzCompressing=false

if [[ $# -gt 1 ]]; then
    for args in "$@"; do
        case $args in
            -u)
                srcOption="-u"
                srcField="_SYSTEMD_UNIT"
                ;;
            -ct)
                needCompressing=true
                tarCompressing=true
                ;;
            -cz)
                needCompressing=true
                zipCompressing=true
                ;;
            -ctg)
                needCompressing=true
                tgzCompressing=true
                ;;
            *)
                ;;
        esac
    done
fi

extractName=${!#}
extractTime="-b 0"

journalctl --list-boot > ${extractName}_extractInfo

journalctl --field=$srcField | while read iden; do
    if [[ $(journalctl -n 1 ${extractTime} $srcOption ${iden}) != "-- No entries --" ]]; then
        journalctl ${extractTime} $srcOption ${iden} > "${extractName}_${iden}"
    else
        echo "[${iden}] does not have any entries for options ${extractTime}" >> ${extractName}_extractInfo
    fi
done

if $needCompressing;then
    if $tarCompressing;then
        tar -cvf archive_${extractName}.tar ${extractName}_*
    elif $zipCompressing;then
        zip archive_${extractName}.zip ${extractName}_*
    elif $tgzCompressing;then
        tar -czvf archive_${extractName}.tgz ${extractName}_*
    else
        exit 1
    fi
    rm ${extractName}_*
fi
