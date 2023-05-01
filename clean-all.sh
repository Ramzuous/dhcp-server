#!/bin/bash

ansible-playbook -i inventory/inventory.yml delete-all.yml --ask-vault-pass

if [ $(grep -c dhcp_server_dev_out vars_files/var_file_strings.yml) == 1 ];
then
	sed -i '/dhcp_server_dev_out/,$d' vars_files/var_file_strings.yml
fi

if [ -d "group_vars" ];
then
	rm -r group_vars
fi

if [ -d "host_vars" ];
then
	rm -r host_vars
fi

if [ -d "inventory" ];
then
	rm -r inventory
fi

echo "******************************";

echo "";

echo "All configuration was cleared";

echo "";

echo "******************************";

echo "";