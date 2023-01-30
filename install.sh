#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

SPATH=$(dirname $0)

set -e

if [ -f "$SPATH/simple-upnpd.c" ] && [ -f "$SPATH/simple-upnpd.service" ]; then
	if [ ! -f "$SPATH/simple-upnpd" ]; then
		make
	fi

	if systemctl is-active --quiet simple-upnpd.service; then
		echo "Stopping simple-upnpd.service..."
		systemctl stop simple-upnpd.service
	fi

	cp -v $SPATH/simple-upnpd /usr/local/bin/simple-upnpd && chmod 755 /usr/local/bin/simple-upnpd
	
	if [ ! -f "/etc/simple-upnpd.xml" ]; then
		if [ -f "$SPATH/simple-upnpd.xml" ]; then
			cp -v $SPATH/simple-upnpd.xml /etc/simple-upnpd.xml && chmod 644 /etc/simple-upnpd.xml
		elif [ -f "$SPATH/description.xml" ]; then
			cp -v $SPATH/simple-upnpd.xml /etc/simple-upnpd.xml && chmod 644 /etc/simple-upnpd.xml
		fi
	fi
	
	if [ -f "/etc/simple-upnpd.xml" ] && ! grep -q "uuid:" /etc/simple-upnpd.xml ; then
		echo "Regenerating UUID..."
		sed "s@<UDN>.*</UDN>@<UDN>uuid:$(cat /proc/sys/kernel/random/uuid)</UDN>@" -i /etc/simple-upnpd.xml
	fi

	cp -v $SPATH/simple-upnpd.service /etc/systemd/system && chmod 644 /etc/systemd/system/simple-upnpd.service
	
	echo "Enabling and starting simple-upnpd.service..."
	systemctl enable simple-upnpd.service && systemctl restart simple-upnpd.service
else
	echo "Missing required files for installation!"
	exit 1
fi
