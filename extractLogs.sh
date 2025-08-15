#This script extract all logs sorted by identifier
#
#journalctl --field=SYSLOG_IDENTIFIER

extractBoot=0
extractName=$1

journalctl --list-boot > ${extractName}_extractInfo

journalctl --field=SYSLOG_IDENTIFIER | while read iden; do
    if [[ $(journalctl -n 1 -b -${extractBoot} -t ${iden}) != "-- No entries --" ]]; then
        journalctl -b -${extractBoot} -t ${iden} > ${extractName}_${iden}
    else
        echo "[${iden}] does not have any entries for boot -${extractBoot}" >> ${extractName}_extractInfo
    fi
done
