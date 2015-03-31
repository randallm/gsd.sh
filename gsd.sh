#!/usr/bin/env bash

# edit this list, or set GSD_SITES to add your custom sites
BASE_SITES="reddit.com news.ycombinator.com"

SITES="$GSD_SITES $BASE_SITES"

HOSTFILE="/etc/hosts"

if [ ! -w $HOSTFILE ]; then
    echo "cannot write to $HOSTFILE, try running with sudo"
    exit 1
fi

# clean up previous entries from /etc/hosts
sed -i -e '/#gsd$/d' $HOSTFILE

# write hosts file if 'work' mode
if [ "$1" != "--play" ]
then
    for SITE in $SITES; do
	    echo -e "127.0.0.1\t$SITE\t#gsd" >> $HOSTFILE
	    echo -e "127.0.0.1\twww.$SITE\t#gsd" >> $HOSTFILE
    done
    echo "work mode enabled, run with --play to disable"
fi

if [ "$(uname -s)" == "Darwin" ]; then
	dscacheutil -flushcache
elif [ "$(uname -s)" == "Linux" ]; then
	for BROWSER in chromium firefox iceweasel; do
		killall $BROWSER > /dev/null 2>&1
	done
fi  
