#!/bin/bash

sudo rm /usr/local/etc/openvswitch/conf.db
sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db /home/anlab/ovs/vswitchd/vswitch.ovsschema

sudo ovsdb-server --remote=ptcp:6640 --remote=punix:/usr/local/var/run/openvswitch/db.sock     --remote=db:Open_vSwitch,Open_vSwitch,manager_options     --private-key=db:Open_vSwitch,SSL,private_key     --certificate=db:Open_vSwitch,SSL,certificate     --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert     --pidfile --detach --log-file

sudo ovs-vsctl --no-wait init
sudo ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true

DB_SOCK=/usr/local/var/run/openvswitch/db.sock
sudo ovs-vswitchd unix:$DB_SOCK --pidfile --detach
