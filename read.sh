#!/bin/bash

INFLUX_HOST="127.0.0.1:8086"
INFLUX_DB="pool_1"
INFLUX_N="jacuzzi_"
for t3 in 8 10 16
do

T3=`modpoll -0 -1 -a 1 -t3 -r $t3 -b 9600 -d 8 -p none /dev/ttyUSB0 | grep -e "$t3"\] | awk -F " " '{ print $2 }'`
curl -s -XPOST "http://$INFLUX_HOST/write?db=$INFLUX_DB" --data-binary "$INFLUX_N$t3 value=$T3"

done

for t4 in 35 36 38
do
T4=`modpoll -1 -a 1 -t4 -r $t4 -b 9600 -d 8 -p none /dev/ttyUSB0 |  grep -e "$t4"\] | awk -F " " '{ print $2 }'`
curl -s -XPOST "http://$INFLUX_HOST/write?db=$INFLUX_DB" --data-binary "$INFLUX_N$t4 value=$T4"
done

#ALARMS1
TA=`modpoll -t3:hex -1  -0 -a 1 -r 1 -b9600 -d8 -pnone /dev/ttyUSB0 | grep -e 1\] | awk -F"x" '{print $2}'`
curl -s -XPOST "http://$INFLUX_HOST/write?db=$INFLUX_DB" --data-binary ""$INFLUX_N"talarm value="$TA""
