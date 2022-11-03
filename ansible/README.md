```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo add-apt-repository ppa:ansible/ansible
sudo apt install ansible
git clone git@github.com:thebengeu/ansible.git ~/ansible
ansible-playbook --extra-vars user=beng ~/ansible/playbook.yml
fisher install IlanCosman/tide@v5
```
