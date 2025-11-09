#This script extract all logs sorted by identifier
#
#journalctl --field=SYSLOG_IDENTIFIER

srcOption="-t"
srcField="SYSLOG_IDENTIFIER"
needCompressing=false
tarCompressing=false
zipCompressing=false
tgzCompressing=false
continuous=false

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
            -C)
                continuous=true
                ;;
            *)
                ;;
        esac
    done
fi

if ${continuous};then
    if [ -f ./.continuous_extractLogs ];then
        extractTime="--since=$(cat ./.continuous_extractLogs)"
    else
        extractTime=""
    fi
else
    extractTime="-b 0"
fi


if [ -f ./.continuous_extractLogs ];then
    rm -f ./.continuous_extractLogs
fi

extractName=${!#}

if ${continuous};then
    until=$(date '+%Y-%m-%dT%H:%M:%S')
    echo "$until" > ./.continuous_extractLogs
    extractTime="${extractTime}  --until=${until}"
    extractName="${extractName}_$(date -d ${until} "+%s")"
    sleep 1
fi

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
