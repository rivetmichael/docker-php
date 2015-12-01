#!/bin/bash
tail -f /var/log/apache2/* &
tail -f /tmp/*.log &
