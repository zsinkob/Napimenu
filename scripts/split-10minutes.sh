#!/bin/bash
outfolder="/var/www/html/ebedmenu/"

dailyfile="10minutes_$(date +%Y-%m-%d)"

echo "${outfolder}${dailyfile}.png"
$(curl "http://10minutes.hu/images/home_1_06.png" > "${outfolder}${dailyfile}.png")
convert "${outfolder}${dailyfile}.png" -negate "${outfolder}${dailyfile}.jpg"

$(tesseract "${outfolder}${dailyfile}.jpg" "${outfolder}${dailyfile}" -l hun)

sed -i '/^\s*$/d' "${outfolder}${dailyfile}.txt"
