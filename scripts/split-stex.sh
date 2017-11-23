#!/bin/bash

outfolder="/var/www/html/ebedmenu/"
function saveday {
fullmenu=$1
position=$2
dayoffset=$3
daywidth=$4

#date=$(date -d "-$(($(date +%w)-${index})) days" +%Y-%m-%d)
date=$(date -d "+$((${dayoffset}-$(date +%w))) days" +%Y-%m-%d)
dailyfile="stex_${date}.jpg"
$(convert "${outfolder}${fullmenu}" -crop "${position}" -fill white -draw "rectangle 0,0 ${daywidth},20" -threshold 50% "${outfolder}$dailyfile")
dailytxt=$(echo $dailyfile | sed -e "s/.jpg//")
echo "${outfolder}$dailyfile"
$(tesseract "${outfolder}$dailyfile" "${outfolder}$dailytxt" -l hun)

}

stexhtml=$(curl -k "http://stexhaz.hu/napimenu")
menufile=$(echo "$stexhtml" | grep -oh "Stex_Het-Menu_.*.jpg")
echo "$menufile"
$(curl "http://stexhaz.hu/sites/default/files/${menufile}" > "${outfolder}${menufile}")

saveday "${menufile}" "692x122+0+216" 1 150 
saveday "${menufile}" "692x122+0+384" 2 150
saveday "${menufile}" "692x122+0+572" 3 172
saveday "${menufile}" "692x122+0+744" 4 218
saveday "${menufile}" "692x122+0+915" 5 164
