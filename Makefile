NEWLINE=UNIX
SHELL=bash

clean:
	find domain ip -type f -name "*" -exec rm -f {} \;

raw: clean
	wget -nv -P domain -i domain.txt
	wget -nv -P ip -i ip.txt

public: raw
	find domain -type f -name "cn-additional-list.txt" -exec sed -i '1d; s/^/\+./' {} +
	find domain ip -type f -name "*.txt" -exec sh -c 'mv "$$0" "$${0%.txt}.list"' {} \;
	find domain ip -type f -name "*.list" -exec sh -c 'mv "$$0" "$${0%.list}.loon.list"' {} \;
	find domain ip -type f -name "*.loon.list" -exec sed -i 's/^\+//' {} +
	find ip -type f -name "*.loon.list" -exec sed -i '/:/s/^/IP-CIDR6,/; /:/!s/^/IP-CIDR,/' {} +
	find ip -type f -name "*.loon.list" -exec sed -i 's/$$/,no-resolve/' {} +
	find domain ip -type f -name "*.loon.list" -exec sh -c 'sort -o "$$0" "$$0"' {} \;
