# Ansible Configurations for ubuntu-server deployments

## Before doing anything please copy your ansible key to your ubuntu-server template for future use.

From your ansible sever run following command to copy the ssh key to template server.

```
ssh-copy-id username@IP(template-server) 
```

## First Cleanup the ubuntu server using ubuntu-cleanup-template.sh script.

```
git clone https://github.com/nirravv/ansible.git
```

```
cd ubuntu-scripts
```

```
chmod u+x ubuntu-cleanup-template.sh
```

```
sudo ./ubuntu-cleanup-template.sh
```

## These steps will cleanup your ubuntu server and shut it down.

## After that please make a template of your ubuntu-server and use playbook to create future VMs out of it.

## Then Just go to following path and set your Vsphere credentials and VM configurations.

```
vi playbooks/deployments/vars/create_ubuntu_vars.yml
```

## Now just run following command to deploy the VM according to varibales you just set up.

```
ansible-playbook playbooks/ubuntu-server/create-ubuntu.yml
```