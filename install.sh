#!/bin/bash

create_symlinks() {
    script_dir=$(dirname "$(readlink -f "$0")")
    
    files=$(find -maxdepth 1 -type f -name ".*")

    for file in $files; do
        name=$(basename "$file")
        if [ ! -L ~/"$name" ]; then  # Vérifie si le lien symbolique existe déjà
            echo "Creating symlink to $name in home repository"
            rm -rf ~/"$name"
            ln -s "$script_dir"/"$name" ~/"$name"
        else
            echo "Symlink to $name already exists, skipping."
        fi
    done

    if [ ! -L ~/.config/nvim ]; then
        mkdir -p ~/.config/
        ln -s "$script_dir"/nvim ~/.config/
    else
        echo "Symlink to nvim already exists, skipping."
    fi

    if [ ! -f ~/.p10k.zsh ]; then
        ln -s "$script_dir/zsh/.p10k.zsh" ~/.p10k.zsh
    else
        echo "~/.p10k.zsh already exists, skipping."
    fi
}

create_symlinks

# Vérification de l'installation de zsh
if ! command -v zsh &> /dev/null; then
    sudo apt install zsh -y
fi

# Vérification de l'installation d'oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 0>/dev/null
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export ZSH_CUSTOM

# Vérification et installation des plugins
plugins=(
    "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
    "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git"
    "zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search"
)

for plugin in "${plugins[@]}"; do
    name=$(echo $plugin | cut -d' ' -f1)
    url=$(echo $plugin | cut -d' ' -f2)
    if [ ! -d "${ZSH_CUSTOM}/plugins/$name" ]; then
        git clone "$url" "${ZSH_CUSTOM}/plugins/$name"
    else
        echo "Plugin $name already installed, skipping."
    fi
done

# Vérification de l'installation de thefuck et autojump
if ! dpkg -l | grep -q thefuck; then
    sudo apt install thefuck -y
fi

if ! dpkg -l | grep -q autojump; then
    sudo apt install autojump -y
fi

# Configuration de ~/.zshrc
if ! grep -q "zsh-syntax-highlighting" ~/.zshrc; then
    sed -i 's/^plugins=.*/plugins=(git\n gitfast\n terraform\n aws\n git-prompt\n direnv\n git-commit\n extract\n thefuck\n autojump\n jsontools\n colored-man-pages\n zsh-autosuggestions\n zsh-syntax-highlighting\n zsh-history-substring-search\n you-should-use\n debian)/g' ~/.zshrc
fi

# Installation et configuration de powerlevel10k
if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
fi

# Ajout du fichier de configuration de p10k dans ~/.zshrc si ce n'est pas déjà fait
if ! grep -q "p10k-instant-prompt" ~/.zshrc; then
    cat << 'EOF' >> ~/.zshrc

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
fi

# Configuration pour les nouveaux utilisateurs (dans /etc/skel)
if [ ! -f /etc/skel/.zshrc ]; then
    sudo cp ~/.zshrc /etc/skel/
    sudo cp ~/.p10k.zsh /etc/skel/
    sudo cp -r ~/.oh-my-zsh /etc/skel/
    sudo chmod -R 755 /etc/skel/
    sudo chown -R root:root /etc/skel/
fi
