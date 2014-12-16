#!/bin/bash -ex

read -p"Nhap port: " port
neutron port-list | awk '/id/ {print $2}' | cut -c 1-11 > port_cut
neutron port-list | awk '/id/ {print $2}' > port_full
paste port_cut port_full > port.txt

index=0
while read line ; do    
    MYARRAY[$index]="$line"
    index=$(($index+1))
done < port.txt
for i in "${MYARRAY[@]}";
do
line_cut=`echo $i | awk '{print $1}'`
line_full=`echo $i | awk '{print $2}'`
if [ "$port" == "$line_cut" ];
then
compute_id=neutron port-show $line_full | awk '/device_id/{print $4}'
nova show $compute_id
rm port.txt
fi
done
