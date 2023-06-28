FROM docker.io/library/php:8-apache

RUN apt-get update && apt-get install -y libcgi-application-perl libtext-markdown-perl

RUN a2enmod cgi cgid
