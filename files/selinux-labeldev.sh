#!/bin/sh

# Copyright (c) 2022, 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear




/usr/sbin/selinuxenabled 2>/dev/null || exit 0

CHCON=/usr/bin/chcon
MATCHPATHCON=/usr/sbin/matchpathcon
RESTORECON=/sbin/restorecon
 
for i in ${CHCON} ${MATCHPATHCON} ${RESTORECON}; do
	test -x $i && continue
	echo "$i is missing in the system."
	echo "Please add \"selinux=0\" in the kernel command line to disable SELinux."
	exit 1
done

# Because /dev/console is not relabeled by kernel, many commands
# would can not use it, including restorecon.
${CHCON} -t `${MATCHPATHCON} -n /dev/null | cut -d: -f3` /dev/null

# Now, we should relabel /dev for most services
# only thing in tmpfs are to be done here other should move
# from this file over the period of time
${RESTORECON} -RF /dev
${RESTORECON} -RF /var
${RESTORECON} -RF /tmp

[ -d /proc/device-tree ] || return
mkdir -p /tmp/sysinfo
[ -e /tmp/sysinfo/board_name ] || \
	echo "$(strings /proc/device-tree/compatible | head -1)" > /tmp/sysinfo/board_name
[ ! -e /tmp/sysinfo/model -a -e /proc/device-tree/model ] && \
	echo "$(cat /proc/device-tree/model)" > /tmp/sysinfo/model

exit 0
