NEWLINE=UNIX
SHELL=bash

clean:
	find geosite geoip -type f -name "*.list*" -exec rm -f {} \;

raw: clean
	wget -nv -P geosite -i geosite.txt
	wget -nv -P geoip -i geoip.txt

public: raw
	find geosite geoip -type f -name "*.list" ! -name "*.raw.list" ! -name "*.loon.list" -exec sh -c 'mv "$$0" "$${0%.list}.raw.list"' {} \;
	find geosite geoip -type f -name "*.raw.list" -exec sh -c 'sed -E "s/^\+//" "$$1" > "$${1%.raw.list}.loon.list"' _ {} \;
	find geoip -type f -name "*.list" -exec sed -i '/:/s/^/IP-CIDR6,/; /:/!s/^/IP-CIDR,/' {} +
	find geosite geoip -type f -name "*.raw.list" ! -name "*.loon.list" -exec sh -c 'mv "$$0" "$${0%.raw.list}.mihomo.list"' {} \;
