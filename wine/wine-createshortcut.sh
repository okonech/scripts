#!/bin/bash
# wine-createshortcut
# by Cleber de Mattos Casali   http://cmcgames.blogspot.com
#
# This script will create a .desktop shortcut for wine applications.

echo
echo wine-createshortcut
echo
echo by Cleber de Mattos Casali   http://cmcgames.blogspot.com

if [ $@ ]; then echo

echo Extract icon...
wine-extracticon "$@"

MYFILE=$(readlink -f "$1")
shift
for i in $@; do MYFILE="$MYFILE $i"; done
MYBASENAME=$(basename "$( readlink -f "$MYFILE")")
MYPATH=$(dirname "$( readlink -f "$MYFILE")")

CATEGORY=$(zenity --title "wine-createshortcut" --height=450 --list --radiolist --column " " --column "Categories" 0 AudioVideo 0 Audio 0 Video 0 Development 0 Education TRUE Game 0 Graphics 0 Network 0 Office 0 Settings 0 System 0 Utility  --text "Select a Category:")

APPNAME=$(zenity --title "wine-createshortcut" --text "Enter a name for your shortcut" --entry)

echo Create shortcut contents...
myshortcut="[Desktop Entry]"\\n"Exec=wine start /Unix \""$MYFILE"\""\\n"Name=$APPNAME"\\n"Path=$MYPATH"\\n"Type=Application"\\n"Categories=Application;$CATEGORY;"\\n"Icon="$MYFILE.icon.png""

echo Create .desktop file...
echo -e $myshortcut >"$MYFILE".desktop

echo Create links on desktop and applications menu...
ln -s "$MYFILE.desktop" "$HOME/Desktop/$MYBASENAME.desktop"
ln -s "$MYFILE.desktop" "$HOME/.local/share/applications/$MYBASENAME.desktop"

echo Done.

else echo; echo Usage : wine-createshortcut myapp.exe ; echo

fi
