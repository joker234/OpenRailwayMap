#vim:ft=Dockerfile
FROM debian:stretch

# List from README
RUN echo "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list 
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        git libgif-dev build-essential g++ make zip sudo curl gawk
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        postgresql-9.6-postgis-2.3
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gzip postgresql-common php-gettext unzip python python-pip python-ply \
        python-imaging python-cairo python-cairosvg librsvg2-2 librsvg2-dev \
        libpango1.0-dev libcairo2-dev libcairomm-1.0-dev libjpeg62-turbo-dev \
        libpangomm-1.4-1v5 libpangomm-1.4-dev wget zlib1g-dev \
        php7.0-pgsql libapache2-mod-php7.0
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        -t stretch-backports npm nodejs 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apache2 apache2-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        osm2pgsql osmctools
RUN DEBIAN_FRONTEND=noninteractive rm -rf /var/lib/apt/lists/* && \
	apt-get clean
RUN pip install -U pip setuptools
RUN pip install pojson

WORKDIR /var/www/html/OpenRailwayMap
COPY . /var/www/html/OpenRailwayMap

RUN git submodule update --init renderer
RUN make install-deps
RUN make
RUN cd renderer && npm install
RUN make -C renderer install-systemd
#RUN cd import && ./import.sh
#RUN cd api && npm install
#RUN make -C api install-systemd

COPY orm.conf /etc/apache2/sites-available/orm.conf
RUN a2dissite 000-default.conf
RUN a2ensite orm.conf
RUN a2dismod mpm_event
RUN a2enmod php7.0



EXPOSE 80

CMD ["./docker-entrypoint.sh"]
