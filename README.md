Chuck's VIM files

To VIM like Chuck:

Backup if you got stuff
-----------

    cd ~
    mv .vim .vim.me
    mv .vimrc .vimrc.me
    mv .gvimrc .gvimrc.me

Get it, link it
-----------

    git clone git@github.com:colczak/chuckvim.git .vim
    ln -s ~/.vim/gvimrc.osx ~/.gvimrc
    ln -s ~/.vim/vimrc.osx ~/.vimrc

Unbundle it
-----------

    cd .vim
    update_bundles.rb

