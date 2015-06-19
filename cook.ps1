# "Clone" the dotfiles repo into home directory
cd $HOME
git init
git remote add origin https://github.com/sapek/dotfiles.git
git fetch
git reset origin/master
git checkout --track origin/master
git submodule init
git submodule update

# Apply the Chef recipe bootstrap
chef-client --local-mode --runlist 'recipe[bootstrap]'
