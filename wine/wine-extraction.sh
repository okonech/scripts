#!/bin/bash
# wine-extracticon

echo Usage : wine-extracticon myapp.exe

MYFILE=$(readlink -f "$1")
shift
for i in $@; do MYFILE="$MYFILE $i"; done
MYBASENAME=$(basename "$( readlink -f "$MYFILE")")

echo "Extracting icon(s)..."
wrestool -x -t 14 "$MYFILE" > "/tmp/$MYBASENAME.ico"

echo Converting icon to PNG...
convert -alpha on "/tmp/$MYBASENAME.ico" "/tmp/$MYBASENAME.png"

#try to copy if there's only 1 icon
cp "/tmp/$MYBASENAME.png" "$MYFILE.icon.png"

#  the script will assume the best icon is the bigger one
echo Copy "$(ls -S -1 "/tmp/$MYBASENAME"*".png" | tac | tail -n 1)" to "$MYFILE.icon.png" ...
cp "$(ls -S -1 "/tmp/$MYBASENAME"*".png" | tac | tail -n 1)" "$MYFILE.icon.png"

echo "Done."