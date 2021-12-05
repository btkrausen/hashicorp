#!/usr/bin/env sh

cp /tmp/assets/webapp /usr/local/bin/
chmod +x /usr/local/bin/*
cp /tmp/assets/webapp.service /lib/systemd/system/webapp.service
service webapp start
systemctl enable webapp

