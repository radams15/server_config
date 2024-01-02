#!/usr/bin/perl

my $OUT_DIR = './conf';

my $SECURE = <<END;
    listen 443 ssl;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_certificate /certs/fullchain.cer;
    ssl_certificate_key /certs/*.therhys.co.uk.key;
END

my $INSECURE = <<END;
listen 80;
END

my $REDIRECT_TEMPLATE = <<END;
server {
    %LISTEN%

    server_name %LOC%;
    return 301 %PROTO%://%LOC%$request_uri;
}
END

my $TEMPLATE = <<END;
server {
    server_name %LOC%;

    %LISTEN%

    location / {
	proxy_pass %IP%;


        proxy_pass_request_headers on;

        proxy_set_header Host \$host;

        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-Host \$http_host;

        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$http_connection;

        proxy_buffering off;
	auth_basic off;
    }
}
END

my @services = (
	{
		LOC => 'therhys.co.uk',
		IP => 'http://host.containers.internal:8080',
		INSECURE => 1,
		REDIRECT => 0
	},
	{
		LOC => 'therhys.co.uk',
		IP => 'http://host.containers.internal:8080',
		REDIRECT => 0
	},
	{
		LOC => 'epc.therhys.co.uk',
		IP => 'http://host.containers.internal:3000'
	},
	{
		LOC => 'matrix.therhys.co.uk',
		IP => 'http://host.containers.internal:8008'
	}
);

system("rm -f $OUT_DIR/*");

my $i=0;
for my $service (@services) {
	my $server = $TEMPLATE;
	my %conf = %$service;

	my $redirect = $REDIRECT_TEMPLATE;

	$server =~ s/%LOC%/$conf{LOC}/g;
	$server =~ s/%IP%/$conf{IP}/g;

	$redirect =~ s/%LOC%/$conf{LOC}/g;

	if($conf{INSECURE}) {
		$server =~ s/%LISTEN%/$INSECURE/g;
		$redirect =~ s/%LISTEN%/$SECURE/g;
		$redirect =~ s/%PROTO%/http/g;
	} else {
		$server =~ s/%LISTEN%/$SECURE/g;
		$redirect =~ s/%LISTEN%/$INSECURE/g;
		$redirect =~ s/%PROTO%/https/g;
	}

	open FH, '>', "$OUT_DIR/$i.conf";
	print FH "$server\n";
	close FH;

	if(!defined($conf{REDIRECT}) || $conf{REDIRECT} == 1) {
		open FH, '>', "$OUT_DIR/$i.redirect.conf";
		print FH "$redirect\n";
		close FH;
	}
	$i++;
}
