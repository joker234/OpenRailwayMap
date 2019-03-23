#!/bin/bash

sudo -u postgres createuser openrailwaymap
sudo -u postgres createdb -E UTF8 -O openrailwaymap openrailwaymap

sudo -u postgres psql -d openrailwaymap -c "CREATE EXTENSION postgis;"
sudo -u postgres psql -d openrailwaymap -c "CREATE EXTENSION postgis_topology;"
sudo -u postgres psql -d openrailwaymap -c "CREATE EXTENSION postgis_sfcgal;"
sudo -u postgres psql -d openrailwaymap -c "CREATE EXTENSION hstore;"

#sudo service postgresql initdb
sudo service postgresql start
#sudo chkconfig postgresql on

echo "localhost:5432:openrailwaymap:openrailwaymap:${PGPASSWORD}" > ~/.pgpass
chmod 600 ~/.pgpass
