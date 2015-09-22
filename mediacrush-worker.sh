#!/bin/sh
# `setuser` is part of baseimage-docker. `setuser mecached xxx...` runs the given command
# (`xxx...`) as the user `memcache`. If you omit this, the command will be run as root.
exec /sbin/setuser app /usr/bin/mediacrush-worker >>/var/log/mediacrush-worker.log 2>&1
