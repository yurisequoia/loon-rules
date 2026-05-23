NEWLINE=UNIX
SHELL=bash

clean:
	find domain ip -type f -name "*" -exec rm -f {} \;

raw: clean
	wget -nv -P domain -i domain.txt
	wget -nv -P ip -i ip.txt
	find domain ip -type f -name "*.txt" -exec sh -c 'mv "$$0" "$${0%.txt}.raw.txt"' {} \;
	find domain ip -type f -name "*.list" -exec sh -c 'mv "$$0" "$${0%.list}.raw.list"' {} \;

public: raw
# DOMAIN
	find domain -type f -name "cn-additional-list.raw.txt" -exec sed -i '1d; s/^/./' {} +
	find domain -type f -name "cn-additional-list.raw.txt" -exec sh -c 'mv "$$0" "$${0%.raw.txt}.list"' {} \;
	find domain -type f -name "*.raw.list" -exec sed -i 's/^\+//' {} +
# IP
	find ip -type f -name "*.raw.txt" -exec sh -c 'mv "$$0" "$${0%.raw.txt}.raw.list"' {} \;
	find ip -type f -name "*.raw.list" -exec sed -i '/:/s/^/IP-CIDR6,/; /:/!s/^/IP-CIDR,/' {} +
	find ip -type f -name "*.raw.list" -exec sed -i 's/$$/,no-resolve/' {} +

# FINAL
	find domain ip -type f -name "*.raw.list" -exec sh -c 'mv "$$0" "$${0%.raw.list}.list"' {} \;
	find domain ip -type f -name "*.list" -exec sh -c 'sort -o "$$0" "$$0"' {} \;
