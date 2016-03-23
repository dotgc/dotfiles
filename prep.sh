cd ~/
echo "Downloading setup files in ~/shell_setup"
mkdir shell_setup
cd shell_setup
wget https://raw.githubusercontent.com/dotgc/dotfiles/master/shell_setup/util.py
wget https://raw.githubusercontent.com/dotgc/dotfiles/master/shell_setup/bootstrap.py
echo 'Usage: python ~/shell_setup/bootstrap.py [-h]'

