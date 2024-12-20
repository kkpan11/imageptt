#!/bin/sh

export BBSHOME=${HOME}

# check environment
env

set -eux

## clone current repo, build and install it
git clone https://github.com/ptt/pttbbs.git ${BBSHOME}/pttbbs
cd ${BBSHOME}/pttbbs
cp -v /tmp/pttbbs.conf ${BBSHOME}/pttbbs/pttbbs.conf
cp -v /tmp/initbbs.c ${BBSHOME}/pttbbs/util/initbbs.c
git apply /tmp/0001-util-poststat.c-fix-implicit-argument-problem.patch
git apply /tmp/0002-util-topusr.c-fix-implicit-argument-problem.patch
# use "pmake" as alias for supporting bmake using NetBSD specific Makefile rules 
pmake all install

## install logind for enabling websocket feature
cd ${BBSHOME}/pttbbs/daemon/logind
pmake all install

## Bootstrap sample BBS theme
cd ${BBSHOME}/pttbbs/sample
pmake install
cp -v etc/reg.methods ${BBSHOME}/etc/

## Clear object near source code
cd ${BBSHOME}/pttbbs
pmake clean

## Startup basic BBS Structure
${BBSHOME}/bin/initbbs -DoIt

## install configurations of telnet/websocket connection service
cp -v /tmp/bindports.conf ${BBSHOME}/etc/bindports.conf
cp -vr ${BBSHOME}/pttbbs/daemon/wsproxy ${BBSHOME}/wsproxy
