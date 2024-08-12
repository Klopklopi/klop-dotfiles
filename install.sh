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

}

create_symlinks

# Credit: Joe Previte (@jsjoeio) - https://github.com/jsjoeio/dotfiles/blob/master/install.sh
###########################
# zsh setup
###########################
echo -e "⤵ Installing zsh..."
sudo apt-get -y install zsh
echo -e ":white_check_mark: Successfully installed zsh version: $(zsh --version)"

# Set up zsh tools
PATH_TO_ZSH_DIR=$HOME/.oh-my-zsh
echo -e "Checking if .oh-my-zsh directory exists at $PATH_TO_ZSH_DIR..."
if [ -d $PATH_TO_ZSH_DIR ]; then
	echo -e "\n$PATH_TO_ZSH_DIR directory exists!\nSkipping installation of zsh tools.\n"
else
	echo -e "\n$PATH_TO_ZSH_DIR directory not found."
	echo -e "⤵ Configuring zsh tools in the $HOME directory..."

	(cd $HOME && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended)
	echo -e ":white_check_mark: Successfully installed zsh tools"
fi

# Set up symlink for .zshrc
ZSHRC_LINK=$HOME/.zshrc
if [ -L ${ZSHRC_LINK} ]; then
	if [ -e ${ZSHRC_LINK} ]; then
		echo -e "\n.zshrc is symlinked corrected"
	else
		echo -e "\nOops! Your symlink appears to be broken."
	fi
elif [ -e ${ZSHRC_LINK} ]; then
	echo -e "\nYour .zshrc exists but is not symlinked."
	# We have to symlink the .zshrc after we curl the install script
	# because the default zsh tools installs a new one, even if it finds ours
	rm $HOME/.zshrc
	echo -e "⤵ Symlinking your .zshrc file"
	ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc
	echo -e ":white_check_mark: Successfully symlinked your .zshrc file"
else
	echo -e "\nUh-oh! .zshrc missing."
fi

# Set the default shell
echo -e "⤵ Changing the default shell"
sudo chsh -s $(which zsh) $USER
echo -e ":white_check_mark: Successfully modified the default shell"

###########################
# end zsh setup
###########################
