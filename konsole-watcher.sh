#!/bin/bash
# Configuration
COMMAND=''
WATCH_INTERVAL_SECONDS=15
SAVEFILE_TERMINAL="${HOME}/.konsole/current-tabs"

# Restore if asked to
if [ "$1" = "restore" ] ; then
    echo "Restoring..."
    konsole --tabs-from-file ${SAVEFILE_TERMINAL} -e 'bash -c exit'&
fi

if [ "$2" = "once" ] ; then
    exit
fi

# Function to get the current sessions and write them to a file
function getSessions {
    pid=$(pgrep konsole -u $USER)
    local SESSIONS=$(qdbus org.kde.konsole-$pid | grep '/Sessions/')
    if [[ ${SESSIONS} ]] ; then
       echo "# Most recent session list " $(date) > ${SAVEFILE_TERMINAL}
       for i in ${SESSIONS}; do
       local FORMAT=$(qdbus org.kde.konsole-$pid $i tabTitleFormat 0)
       local PROCESSID=$(qdbus org.kde.konsole-$pid $i processId)
       local CWD=$(pwdx ${PROCESSID} | sed -e "s/^[0-9]*: //")
       if [[ $(pgrep --parent ${PROCESSID}) ]] ; then
           CHILDPID=$(pgrep --parent ${PROCESSID})
           COMMAND=$(ps -p ${CHILDPID} -o args=)
       fi 
       echo "workdir: ${CWD};; title: ${FORMAT};; command:${COMMAND}" >> ${SAVEFILE_TERMINAL}
       COMMAND=''
       done
    fi
}

#Update the Konsole sessions every WATCH_INTERVAL_SECONDS seconds
while true; do sleep ${WATCH_INTERVAL_SECONDS}; getSessions; done &
