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

# Cloner votre repository GitHub (remplacez URL_DE_VOTRE_REPO par l'URL réelle)
git clone https://github.com/Klopklopi/klop-dotfiles ~/klop-dotfiles
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}"/themes/powerlevel10k

# Copier le fichier .zshrc de votre repository vers votre répertoire personnel
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp ~/klop-dotfiles/zsh/.zshrc ~/.zshrc
source ~/.zshrc
