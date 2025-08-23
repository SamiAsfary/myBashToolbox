#This script extract all logs sorted by identifier
#
#journalctl --field=SYSLOG_IDENTIFIER

srcOption="-t"
srcField="SYSLOG_IDENTIFIER"

if [[ $# -gt 1 ]]; then
    for args in "$@"; do
        case $args in
            -u)
                srcOption="-u"
                srcField="_SYSTEMD_UNIT"
                ;;
            *)
                ;;
        esac
    done
fi

extractBoot=0
extractName=${!#}

journalctl --list-boot > ${extractName}_extractInfo

journalctl --field=$srcField | while read iden; do
    if [[ $(journalctl -n 1 -b -${extractBoot} $srcOption ${iden}) != "-- No entries --" ]]; then
        journalctl -b -${extractBoot} $srcOption ${iden} > "${extractName}_${iden}"
    else
        echo "[${iden}] does not have any entries for boot -${extractBoot}" >> ${extractName}_extractInfo
    fi
done
