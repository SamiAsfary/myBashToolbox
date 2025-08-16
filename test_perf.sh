CPUn=(cpu cpu0 cpu1 cpu2 cpu3)

#Time;CPUusr;CPUnice;CPUsys;CPUidle;CPUsoftIRQ;CPUiusr;CPUinice;CPUisys;CPUiidle;CPUisoftIRQ;
while true; do

#allJiffies
# sudo cat /proc/timer_list | grep 'jiffies:' | grep -Eo "[0-9]+" | while read line;do
#     echo -n "${line};" >> $1
# done

#Check time
echo -n `date +"%D;%T;"` >> $1

#Check each CPU
for i in ${!CPUn[@]}
do 
    resCPU=(`cat /proc/stat | grep "${CPUn[$i]} "`)
    for j in $(seq 1 10); do
        echo -n "${resCPU[$j]};" >> $1
    done
done

#Check Memory 
#meminfo=`cat /proc/meminfo` 
cat /proc/meminfo | grep -Eo "[0-9]+" | while read line;do
    echo -n "${line};" >> $1
done

#Check Memory top
# resMem=(`top -n1 -b | head -n4 | tail -n1`)
# echo -n "${resMem[3]};${resMem[5]};${resMem[7]};${resMem[9]};" >> $1

# #Check CPU top  us;sy;ni;id;wa;hi;si;st
# resCPUtop=(`top -n1 -b | head -n3 | tail -n1`)
# for i in $(seq 1 2 16);do
# echo -n "${resCPUtop[i]};" >> $1
# done

#debugDeltaTime
#echo -n `date +"%D;%T;"` >> $1
# sudo cat /proc/timer_list | grep 'jiffies:' | grep -Eo "[0-9]+" | while read line;do
#     echo -n "${line};" >> $1
# done
#LineReturn
echo "" >> $1
sleep 30
done
#cat /proc/stat | grep "^cpu "
#top -n1 | head -n4 | tail -n1
#%Cpu(s): 74,6 us, 19,0 sy,  0,0 ni,  6,3 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
#MiB Mem :   7445,7 total,   1190,8 free,   1875,9 used,   4379,0 buff/
#cpu  597986 37 148414 99027 1726 0 22046 0 0 0
#cpu0 152822 2 34926 26314 364 0 2342 0 0 0
#cpu1 146630 17 37992 23707 591 0 8693 0 0 0
#cpu2 146750 12 39592 22590 390 0 8604 0 0 0
#cpu3 151782 4 35903 26415 379 0 2406 0 0 0
