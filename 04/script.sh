#!/bin/bash

number=$(cat ./lines 2>/dev/null)
Lines=$(wc ./access-4560-644067.log | awk '{print $1}')
logpath=access-4560-644067.log
top_points_number=5

sorter(){
sort | uniq -c | sort -nr
}

top_points(){
head -$top_points_number
}

top_domain(){
awk '{print $13}' $logpath | grep http | awk 'BEGIN { FS = "/" } ; { print $3 }' | awk 'BEGIN { FS = "\"" } ; { print $1 }' | sorter | top_points
}

url_err(){ 
awk '{print $9}' $logpath | awk -F '.-' '$1 <= 599 && $1 >= 400' | sorter
}

timest(){
awk '{print $4 $5}' $logpath | sed 's/\[//; s/\]//'
}

if [[ -z "$number" ]];
then
    timestart=$(timest | sed -n 1p)
    timeend=$(timest | sed -n "$Lines"p)
    echo $Lines > ./lines
    ipsh=$(awk 'NR>$Lines' $logpath | awk '{print $1}' | sorter | awk '{ if ( $1 >= 0 ) { print "Количество запросов: " $1, "IP:" $2 } }' | top_points)
    addresses=$(awk '($9 ~ /200/)' $logpath | awk '{print $7}' | sorter | awk '{ if ( $1 >= 10 ) { print "Количество запросов: " $1, "URL:" $2 } }' | top_points)
    errors=$(url_err)
    domains=$(top_domain)
    echo -e "Данные с $timestart по $timeend\n\n$domains\n\nТоп $top_points_number IP:\n$ipsh\n\nТоп $top_points_number адресов:\n$addresses\n\nОшибки:\n$errors" | mail -s "NGINX Log" root@localhost
    echo "Mail with data sent - first"
else
    timestart=$(timest | sed -n "$(($number+1))"p)
    timeend=$(timest | sed -n "$Lines"p)
    ipsh=$(awk 'NR>$(($number+1))' $logpath | awk '{print $1}' | sorter | awk '{ if ( $1 >= 0 ) { print "Количество запросов: " $1, "IP:" $2 } }' | top_points)
    addresses=$(awk '($9 ~ /200/)' $logpath | awk '{print $7}' | sorter | awk '{ if ( $1 >= 10 ) { print "Количество запросов: " $1, "URL:" $2 } }' | top_points)
    errors=$(url_err)
    domains=$(top_domain)
    echo $Lines > ./lines
    echo -e "Данные с $timestart по $timeend\n\n$domains\n\nТоп $top_points_number IP:\n$ipsh\n\nТоп $top_points_number адресов:\n$addresses\n\nОшибки:\n$errors" | mail -s "NGINX Log" root@localhost
    echo "Mail with data sent - continues"
fi
