#! /bin/bash

create_symlinks() {
	script_dir=$(dirname "$(readlink -f "$0")")

	files=$(find -maxdepth 1 -type f -name ".*")

	for file in $files; do
		name=$(basename "$file")
		echo "Creating symlink to $name in home repository"
		rm -rf ~/"$name"
		ln -s "$script_dir"/"$name" ~/"$name"
	done

	if [ ! -d ~/.config/nvim ]; then
		mkdir -p ~/.config/
		ln -s "$script_dir"/nvim ~/.config/
	fi

	 # Vérifier si le fichier ~/.p10k.zsh n'existe pas
	if [ ! -f ~/zsh/.p10k.zsh ]; then
	    # Créer un lien symbolique vers le fichier .p10k.zsh dans le répertoire script_dir
	    ln -s "$script_dir/.p10k.zsh" ~/.p10k.zsh
	fi
}

create_symlinks

#!/bin/bash

sudo apt install zsh -y
# Install oh-my-zsh.
0>/dev/null sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export ZSH_CUSTOM
# Configure plugins.
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search "${ZSH_CUSTOM}"/plugins/zsh-history-substring-search
sudo apt install thefuck autojump -y
sed -i 's/^plugins=.*/plugins=(git\n gitfast\n terraform\n aws\n git-prompt\n direnv\n git-commit\n extract\n thefuck\n autojump\n jsontools\n colored-man-pages\n zsh-autosuggestions\n zsh-syntax-highlighting\n zsh-history-substring-search\n you-should-use\n debian)/g' ~/.zshrc
# Install powerlevel10k and configure it.
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}"/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
# Move ".zcompdump-*" file to "$ZSH/cache" directory.
sed -i -e '/source \$ZSH\/oh-my-zsh.sh/i export ZSH_COMPDUMP=\$ZSH\/cache\/.zcompdump-\$HOST' ~/.zshrc
# Configure the default ZSH configuration for new users.
sudo cp ~/.zshrc /etc/skel/
sudo cp ~/.p10k.zsh /etc/skel/
sudo cp -r ~/.oh-my-zsh /etc/skel/
sudo chmod -R 755 /etc/skel/
sudo chown -R root:root /etc/skel/
