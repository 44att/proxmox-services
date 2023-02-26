# Proxmox services

Terraform/Ansible scripts to setup self-hosted services on Proxmox

```bash
./terraform/

terraform init

terraform apply

terraform destroy -target=proxmox_lxc.unifi
```

```bash
./ansible/

ansible-playbook ./playbooks/jellyfin.yml

ansible-playbook ./playbooks/pi-hole.yml --tags "dns" --list-tasks
```

```bash
ssh-keygen -R "traefik.test"; ssh-keygen -R "192.168.1.4"
```
