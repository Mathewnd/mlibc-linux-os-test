#!/usr/bin/bash

mkdir -p /dev
if [ ! -f /dev/null ]; then
	mknod -m 666 /dev/null c 1 3
	chown root:root /dev/null
fi
if [ ! -f /dev/zero ]; then
	mknod -m 666 /dev/zero c 1 5
	chown root:root /dev/zero
fi

mkdir -p /dev/pts
mount -t devpts pts /dev/pts
ln -s /dev/pts/ptmx /dev/ptmx

mkdir -p /tmp

set +e
cd /usr/share/os-test
make test OS=mlibc

umount /dev/pts
