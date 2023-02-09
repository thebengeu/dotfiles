```shell
sudo add-apt-repository ppa:ansible/ansible
sudo apt install ansible
git clone git@github.com:thebengeu/ansible.git ~/ansible
ansible-playbook --ask-become-pass --extra-vars user=${USER} --tags server ~/ansible/site.yml
op account add
eval $(op signin)
tide configure
bat cache --build
```
