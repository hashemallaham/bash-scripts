#!/bin/bash

sudo cat /var/log/apt/history.log | grep "apt install" -B 1
