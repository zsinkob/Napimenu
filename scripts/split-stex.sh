#!/bin/bash

outfolder="/var/www/html/ebedmenu/"
function saveday {
fullmenu=$1
position=$2
dayoffset=$3
daywidth=$4

dailyfile="stex_$(date -d "+${dayoffset} days" +%Y-%m-%d).jpg"
$(convert "${outfolder}${fullmenu}" -crop "${position}" -fill white -draw "rectangle 0,0 ${daywidth},20" -threshold 50% "${outfolder}$dailyfile")
dailytxt=$(echo $dailyfile | sed -e "s/.jpg//")
$(tesseract "${outfolder}$dailyfile" "${outfolder}$dailytxt" -l hun)

}

stexhtml=$(curl -k "http://stexhaz.hu/napimenu")
menufile=$(echo "$stexhtml" | grep -oh "Stex_Het-Menu_.*.jpg")
echo "$menufile"
$(curl "http://stexhaz.hu/sites/default/files/${menufile}" > "${outfolder}${menufile}")

saveday "${menufile}" "692x122+0+216" +0 150 
saveday "${menufile}" "692x122+0+384" +1 150
saveday "${menufile}" "692x122+0+552" +2 172
saveday "${menufile}" "692x122+0+724" +3 218
saveday "${menufile}" "692x122+0+890" +4 164
