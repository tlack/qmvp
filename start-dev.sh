. ./config.sh
echo starting $APPNAME on $DEVPORT
q $APPNAME -l -p localhost:$DEVPORT 2>&1 | tee -a /tmp/q-$APPNAME-dev.log

