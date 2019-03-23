#!/bin/bash

service postgresql restart

if [ ! -f db-setup-done ]; then
    ./db-setup.sh && touch db-setup-done
fi

service apache2 restart
#systemctl restart orm-tileserver.service
#systemctl restart orm-api.service

bash
