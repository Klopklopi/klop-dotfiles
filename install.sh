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

# Copier le fichier .zshrc de votre repository vers votre répertoire personnel
cp ~/klop-dotfiles/zsh/.zshrc ~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}"/themes/powerlevel10k
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
