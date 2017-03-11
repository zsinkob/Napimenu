#!/bin/bash

inputfile=$1
outfolder="/var/www/html/ebedmenu/" 
echo "${inputfile}"

convert ${inputfile} -sharpen 10 "${outfolder}bridges.tif"
$(tesseract "${outfolder}bridges.tif" "${outfolder}bridges.txt" -l hun hocr)

function getDailyMenu {

current=$1
next=$2
index=$3
date=$(date -d "+${index} days" +%Y-%m-%d)
if [[ -z $current ]]; then
	echo "cannot find ${current} offset ${3}"
	cp ${inputfile} "${outfolder}bridges_$date.jpg"
 else

x1="$(cut -d' ' -f2 <<< "$current")"
y1="$(cut -d' ' -f3 <<< "$current")"
x2="$(cut -d' ' -f4 <<< "$current")"
y2="$(cut -d' ' -f5 <<< "$current")"

echo "$current"
echo "x1 ${x1} - y1 ${y1} - x2 ${x2} - y2 ${y2}" 

nexty="$(cut -d' ' -f3 <<< "$next")"

cropx=$(( $x1 - 4 * ( $x2 - $x1 ) - 20 ))
cropy=$(($y2+10))

width=$((($x2-$x1)*11))
if [[ -z $nexty ]]; then
	height=$(((y2-y1) * 4 + 10))
else
	height=$(($nexty-y2-10))
fi

echo "${width}x${height}+${cropx}+${cropy}"
convert "${outfolder}bridges.tif" -crop "${width}x${height}+${cropx}+${cropy}" "${outfolder}bridges_$date.jpg"
fi

}

hetfo=$(grep -i 'H[ée]tf[oőö]' "${outfolder}bridges.txt.hocr" | egrep -o "bbox.*; baseline" | egrep -o "[0-9 ]+")
kedd=$(grep -i 'Ke[_]?dd' "${outfolder}bridges.txt.hocr" | egrep -o "bbox.*; baseline" | egrep -o "[0-9 ]+")
szerda=$(grep -i 'erda' "${outfolder}bridges.txt.hocr" | egrep -o "bbox.*; baseline" | egrep -o "[0-9 ]+")
csutortok=$(grep -i 'Cs[uüű]t[oöő]rt[oöő]k' "${outfolder}bridges.txt.hocr" | egrep -o "bbox.*; baseline" | egrep -o "[0-9 ]+")
pentek=$(grep -i 'P[eé]ntek' "${outfolder}bridges.txt.hocr" | egrep -o "bbox.*; baseline" | egrep -o "[0-9 ]+")

getDailyMenu "$hetfo" "$kedd" "+0"
getDailyMenu "$kedd" "$szerda" "+1"
getDailyMenu "$szerda" "$csutortok" "+2"
getDailyMenu "$csutortok" "$pentek" "+3"
getDailyMenu "$pentek" "" "+4"
