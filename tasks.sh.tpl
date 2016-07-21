#!/bin/bash

sudo le follow /var/log/apache2/error.log --name Error --host-key {{ LOGENTRIES_HOST_KEY }}
sudo le follow /var/messages --name Messages --host-key {{ LOGENTRIES_HOST_KEY }}
