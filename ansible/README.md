```shell
ssh-keygen -t ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
rm ~/.ssh/id_ed25519.pub
sudo add-apt-repository ppa:ansible/ansible
sudo apt install ansible
git clone git@github.com:thebengeu/ansible.git ~/ansible
ansible-playbook --extra-vars user=$USER --tags server ~/ansible/site.yml --ask-become-pass
chezmoi apply
tide configure
cp ~/.wezterm.lua /mnt/c/Users/beng
aws configure
sudo -u postgres psql # \password
```
