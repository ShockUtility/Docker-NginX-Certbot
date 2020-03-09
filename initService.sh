#!/bin/bash

service cron start
service fcgiwrap start
nginx -g 'daemon off;'