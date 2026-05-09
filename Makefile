NEWLINE=UNIX
SHELL=bash

clean:
	find geosite geoip -type f -name "*.list*" -exec rm -f {} \;

raw: clean
	wget -nv -P geosite -i geosite.txt
	wget -nv -P geoip -i geoip.txt

public: raw
	find geosite geoip -type f -name "*.list" -exec sh -c 'mv "$$0" "$${0%.list}.loon.list"' {} \;
	find geosite geoip -type f -name "*.loon.list" -exec sed -i 's/^\+//' {} +
	find geoip -type f -name "*.loon.list" -exec sed -i '/:/s/^/IP-CIDR6,/; /:/!s/^/IP-CIDR,/' {} +
	find geoip -type f -name "*.loon.list" -exec sed -i 's/$$/,no-resolve/' {} +
