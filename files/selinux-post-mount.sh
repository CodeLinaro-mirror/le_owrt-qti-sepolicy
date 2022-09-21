#!/bin/sh

# Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
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

# file/dir  mounted  post should be relabeld here .
${RESTORECON} -F /data /var
exit 0
