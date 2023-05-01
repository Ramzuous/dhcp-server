#!/bin/bash

#############################################
# Variables to set

# ansible vars
dhcp_server_ip=""
ansible_user=""
ansible_password=""
ansible_port=""
ansible_connection=""

# dhcp server vars
dhcp_server_dev_out=""
option_domain_name=""
option_domain_name_servers=""
default_lease_time=""
max_lease_time=""

#############################################

echo "******************************";

echo ""

echo "Welcom to preparation script";

echo "";

echo "******************************";

echo "";

############################################

echo "Create required folders";

echo "";

if [ ! -d group_vars ];
then
	mkdir group_vars
fi

if [ ! -d host_vars ];
then
	mkdir host_vars
fi

if [ ! -d inventory ];
then
	mkdir inventory
fi

#########################################

echo "Create and set required files";

echo "";

if [ ! -f group_vars/linuxservices.yml ];
then
	
	echo "ansible_user: "$ansible_user >> group_vars/linuxservices.yml
	
	echo "Set ansible vault";
	
	echo "";
	
	ansible-vault encrypt_string $ansible_password >> group_vars/linuxservices.yml
	
	sed -i 's/!vault /ansible_password: !vault /' group_vars/linuxservices.yml
	
	echo "";
	
	echo "ansible_port: "$ansible_port >> group_vars/linuxservices.yml
	
	echo "ansible_connection: "$ansible_connection >> group_vars/linuxservices.yml
	
fi

if [ ! -f host_vars/dhcp-server.yml ];
then
	
	echo "ansible_host: "$dhcp_server_ip >> host_vars/dhcp-server.yml
	
fi

if [ ! -f inventory/inventory.yml ];
then

	echo "all:" >> inventory/inventory.yml
	echo "  children:" >> inventory/inventory.yml
	echo "    linuxservices:" >> inventory/inventory.yml
	echo "      children:" >> inventory/inventory.yml
	echo "        debianbased:" >> inventory/inventory.yml
	echo "          hosts:" >> inventory/inventory.yml
	echo "            dhcp-server:" >> inventory/inventory.yml

fi

#########################################

if [ $(grep -c "dhcp_server_dev_out:" vars_files/var_file_strings.yml) == 0 ];
then
	echo "dhcp_server_dev_out: "$dhcp_server_dev_out >> vars_files/var_file_strings.yml
fi

if [ $(grep -c "option_domain_name:" vars_files/var_file_strings.yml) == 0 ];
then
	echo "option_domain_name: "$option_domain_name >> vars_files/var_file_strings.yml
fi

if [ $(grep -c "option_domain_name_servers:" vars_files/var_file_strings.yml) == 0 ];
then
	echo "option_domain_name_servers: "$option_domain_name_servers >> vars_files/var_file_strings.yml
fi

if [ $(grep -c "default_lease_time:" vars_files/var_file_strings.yml) == 0 ];
then
	echo "default_lease_time: "$default_lease_time >> vars_files/var_file_strings.yml
fi

if [ $(grep -c "max_lease_time:" vars_files/var_file_strings.yml) == 0 ];
then
	echo "max_lease_time: "$max_lease_time >> vars_files/var_file_strings.yml
fi

if [ $(grep -c "networks_to_set_vars:" vars_files/var_file_strings.yml) == 0 ];
then

	echo "networks_to_set_vars:" >> vars_files/var_file_strings.yml
	echo "#settings of users, example:" >> vars_files/var_file_strings.yml
	echo '#  - { interface: "eth0.1000", subnet: "172.16.10", netmask: "255.255.255.0", ip_range: "172.16.10.10 172.16.10.50" }' >> vars_files/var_file_strings.yml
	
fi

if [ $(grep -c "networks_to_delete_vars:" vars_files/var_file_strings.yml) == 0 ];
then

	echo "networks_to_delete_vars:" >> vars_files/var_file_strings.yml
	echo "#users to delete, example:" >> vars_files/var_file_strings.yml
	echo '#  - 172.16.10' >> vars_files/var_file_strings.yml
	
fi

echo "******************************";

echo "";

echo "All settings are ready";

echo "";

echo "To install server, run:";

echo "";

echo "ansible-playbook -i inventory/inventory.yml install-dhcp-server.yml --ask-vault-pass";

echo "";

echo "To create networks, run:";

echo "";

echo "ansible-playbook -i inventory/inventory.yml create-network.yml --ask-vault-pass";

echo "";

echo "remember to set networks_to_set_vars in file vars_files/var_file_strings.yml";

echo "";

echo "To delete networks, run:";

echo "";

echo "ansible-playbook -i inventory/inventory.yml delete-network.yml --ask-vault-pass";

echo "";

echo "remember to set networks_to_delete_vars in file vars_files/var_file_strings.yml";

echo "";

echo "To delete server and all settings, run:";

echo "";

echo "./clean-all.sh";

echo "";

echo "******************************";

echo "";
