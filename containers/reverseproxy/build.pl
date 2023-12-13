#!/usr/bin/perl

my $OUT_DIR = './conf';

my $TEMPLATE = <<END;
server {
    server_name %LOC%;
    listen 443 ssl;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_certificate /certs/fullchain.cer;
    ssl_certificate_key /certs/*.therhys.co.uk.key;
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
		IP => 'http://host.containers.internal:8080'
	},
	{
		LOC => 'epc.therhys.co.uk',
		IP => 'http://host.containers.internal:7000'
	}
);

system("rm -f $OUT_DIR/*");

my $i=0;
for my $service (@services) {
	my $server = $TEMPLATE;
	while(my ($k, $v) = each(%$service)) {
		$server =~ s/%$k%/$v/g;
	}

	open FH, '>', "$OUT_DIR/$i.conf";
	print FH "$server\n";
	close FH;
	$i++;
}
