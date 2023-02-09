```shell
sudo add-apt-repository ppa:ansible/ansible
sudo apt install ansible
git clone git@github.com:thebengeu/ansible.git ~/ansible
op account add
eval $(op signin)
ansible-playbook --ask-become-pass --extra-vars user=${USER} --tags server ~/ansible/site.yml
tide configure
```
