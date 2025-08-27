#!/bin/bash

# このスクリプトはUbuntu環境での開発環境セットアップを自動化します。
# 実行方法: bash setup.sh
# または source <(curl -s <このスクリプトのURL>)

# 前提条件:
# - Ubuntu OSであること
# - git, curl がインストールされていること (apt_updateでインストールされますが、初期実行に必要)


# スクリプトの途中でエラーが発生した場合、スクリプトの実行を中止する
set -e

# 区切り線
___() {
    echo -e "\n------------------------------------------------------------"
}

# OSの確認 (Ubuntu以外はエラー終了)
check_os() {
    if ! grep -qi "ubuntu" /etc/os-release; then
        echo "★ Error: This script is designed to run on Ubuntu only."
        exit 1
    fi
    echo "★ OS check passed: Ubuntu detected."
}

# GitHub CLI (`gh`) のインストール
install_gh() {
    eval "$(mise activate bash || true)"
    if ! command -v gh >/dev/null 2>&1 || ! mise which gh >/dev/null 2>&1; then
        echo "★ GitHub CLI (gh) is not installed. Installing gh using mise..."
        mise use -g gh@latest
        GH_VERSION=$(get_mise_tool_version gh)
        echo "★ GitHub CLI installation completed!! ($GH_VERSION)"
    else
        GH_VERSION=$(get_mise_tool_version gh)
        echo "★ GitHub CLI (managed by mise) is already installed. ($GH_VERSION)"
    fi
}

# SSHキーのセットアップとGitHubへの登録 (対話/非対話 環境対応)
setup_github_ssh() {
    echo "★ Setting up SSH key for GitHub..."
    # miseを有効化して、インストール済みのghコマンドを使えるようにする
    eval "$(mise activate bash || true)"

    install_gh # ghコマンドのインストールを確実にする

    # インストールしたghを確実にPATHに含めるため、再度miseを有効化
    eval "$(mise activate bash || true)"

    local ssh_key_path="$HOME/.ssh/id_ed25519"
    local ssh_pub_key_path="${ssh_key_path}.pub"

    # 1. SSHキーが存在しない場合は生成
    if [ ! -f "$ssh_pub_key_path" ]; then
        echo "★ SSH public key not found at $ssh_pub_key_path."
        echo "★ Generating a new SSH key..."
        
        read -p "Enter your GitHub email address: " github_email
        if [ -z "$github_email" ]; then
            echo "★ Error: Email address cannot be empty."
            exit 1
        fi
        
        ssh-keygen -t ed25519 -C "$github_email" -f "$ssh_key_path" -N ""
        echo "★ New SSH key generated."
    else
        echo "★ SSH public key found at $ssh_pub_key_path."
    fi

    # 2. GitHubにログインしているか確認し、していなければ認証処理
    if ! gh auth status -h github.com >/dev/null 2>&1; then
        echo "★ You are not logged in to GitHub CLI."
        
        # 実行環境が対話的(tty)かどうかで認証方法を分岐
        if [ -t 1 ]; then
            # 対話的環境 (通常のターミナル)
            echo "★ Starting interactive authentication. Please follow the browser instructions."
            gh auth login
        else
            # 非対話的環境 (VPSなど)
            echo "★ Non-interactive environment detected."
            echo "★ Please create a GitHub Personal Access Token (PAT) with 'write:public_key' and 'read:public_key' scopes."
            read -s -p "Paste your GitHub PAT here and press Enter: " github_token
            echo
            if [ -z "$github_token" ]; then
                echo "★ Error: GitHub PAT cannot be empty."
                exit 1
            fi
            # トークンを使って認証
            echo "$github_token" | gh auth login --with-token
        fi
    fi
    
    # ログイン状態を最終確認
    if ! gh auth status -h github.com >/dev/null 2>&1; then
         echo "★ Error: GitHub CLI authentication failed. Please try again."
         exit 1
    fi
    echo "★ Successfully authenticated with GitHub CLI."

    # 3. 公開鍵をGitHubにアップロード
    key_title="Auto-uploaded by setup.sh on $(hostname)"
    if ! gh ssh-key list | grep -q "$(cut -d' ' -f 2 < "$ssh_pub_key_path")"; then
        echo "★ Uploading public key to GitHub account..."
        gh ssh-key add "$ssh_pub_key_path" --title "$key_title"
        echo "★ Public key uploaded successfully."
    else
        echo "★ This SSH key is already registered on your GitHub account."
    fi

    # 4. SSH接続をテスト
    echo "★ Testing SSH connection to github.com..."
    ssh_output=$(ssh -o ConnectTimeout=5 -T git@github.com 2>&1 || true)
    if echo "$ssh_output" | grep -q "successfully authenticated"; then
        echo "★ SSH connection to github.com successful!"
    else
        echo "★ Error: Failed to authenticate with github.com via SSH."
        echo "--- SSH Output ---"
        echo "$ssh_output"
        echo "------------------"
        exit 1
    fi
}


# miseのバージョン取得
get_mise_tool_version() {
    local tool_name=$1
    local version=$(mise current "$tool_name" 2>/dev/null | awk '{print $2}')
    if [ -n "$version" ]; then
        echo "$version"
    else
        echo "version check pending"
    fi
}

# --- パッケージ & 基本ツールインストール ---

# apt パッケージの更新と基本ツールのインストール
apt_update() {
    echo "★ Updating apt packages and installing base dependencies..."
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y curl git tmux unzip build-essential
    sudo apt autoremove -y
    echo "★ Base dependencies installed."
}

# --- mise ---

# mise のインストールと設定
install_mise() {
    if [[ ":$PATH:" != ":$HOME/.local/bin:"* ]]; then
        echo "★ Adding ~/.local/bin to PATH in ~/.bashrc"
        if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
            echo '' >> ~/.bashrc; echo '# Add ~/.local/bin to PATH for mise' >> ~/.bashrc; echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        fi
        export PATH="$HOME/.local/bin:$PATH"
        echo "★ Please run 'source ~/.bashrc' or restart your terminal after script finishes."
    fi

    if ! command -v mise >/dev/null 2>&1; then
        echo "★ Installing mise..."
        MISE_URL=https://mise.run
        curl $MISE_URL | sh
        if ! grep -q 'eval "$(mise activate bash)"' ~/.bashrc && [ -f "$HOME/.local/bin/mise" ]; then
            echo "★ Adding mise activate to ~/.bashrc"
            echo '' >> ~/.bashrc; echo '# Initialize mise' >> ~/.bashrc; echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
            eval "$(~/.local/bin/mise activate bash || true)"
            echo "★ Please run 'source ~/.bashrc' or restart your terminal after script finishes."
        fi
        echo "★ mise installation completed!!"
    else
        echo "★ mise is already installed."
        if command -v mise >/dev/null 2>&1;
             then
             eval "$(mise activate bash || true)"
        fi
    fi
}

# --- 言語ランタイム & ツール ---

# Node.js
install_nodejs() {
    eval "$(mise activate bash || true)"
    if ! command -v node >/dev/null 2>&1 || ! mise which node >/dev/null 2>&1;
        then
        echo "★ Node.js (managed by mise) is not installed. Installing the latest Node.js using mise..."
        mise use -g node@latest
        NODE_VERSION=$(get_mise_tool_version node)
        echo "★ Node.js installation completed!! ($NODE_VERSION)"
    else
        NODE_VERSION=$(get_mise_tool_version node)
        echo "★ Node.js (managed by mise) is already installed. ($NODE_VERSION)"
    fi
}

# Deno
install_deno() {
    eval "$(mise activate bash || true)"
    if ! command -v deno >/dev/null 2>&1 || ! mise which deno >/dev/null 2>&1;
        then
        echo "★ Deno (managed by mise) is not installed. Installing the latest Deno using mise..."
        mise use -g deno@latest
        DENO_VERSION=$(get_mise_tool_version deno)
        echo "★ Deno installation completed!! ($DENO_VERSION)"
    else
        DENO_VERSION=$(get_mise_tool_version deno)
        echo "★ Deno (managed by mise) is already installed. ($DENO_VERSION)"
    fi
}

# Bun
install_bun() {
    eval "$(mise activate bash || true)"
    if ! command -v bun >/dev/null 2>&1 || ! mise which bun >/dev/null 2>&1;
        then
        echo "★ Bun (managed by mise) is not installed. Installing the latest Bun using mise..."
        mise use -g bun@latest
        BUN_VERSION=$(get_mise_tool_version bun)
        echo "★ Bun installation completed!! ($BUN_VERSION)"
    else
        BUN_VERSION=$(get_mise_tool_version bun)
        echo "★ Bun (managed by mise) is already installed. ($BUN_VERSION)"
    fi
}

# Python
install_python() {
    eval "$(mise activate bash || true)"
    if ! command -v python3 >/dev/null 2>&1 || ! mise which python >/dev/null 2>&1 ;
        then
        echo "★ Python (managed by mise) is not installed. Installing the latest Python with mise..."
        echo "★ Installing Python build dependencies..."
        sudo apt update -y
        sudo apt install -y libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev python3-openssl
        mise use -g python@latest
        PYTHON_VERSION=$(get_mise_tool_version python)
        PIP_VERSION=$((command -v python >/dev/null && python -m pip --version || echo "pip check failed") 2>/dev/null)
        echo "★ Python installation completed!! ($PYTHON_VERSION, $PIP_VERSION)"
        echo "★ Upgrading pip..."
        if command -v python >/dev/null;
            then
            python -m ensurepip --upgrade || true
            python -m pip install --upgrade pip || true
            PIP_VERSION=$((python -m pip --version || echo "pip check failed") 2>/dev/null)
            echo "★ Pip upgrade attempt finished. ($PIP_VERSION)"
        else
             echo "★ Skipping pip upgrade: python command not found in current PATH."
        fi
    else
        PYTHON_VERSION=$(get_mise_tool_version python)
        # python コマンドが見つからない可能性を考慮
        PIP_VERSION=$((command -v python >/dev/null && python -m pip --version || echo "pip check failed") 2>/dev/null)
        echo "★ Python (managed by mise) is already installed. ($PYTHON_VERSION, $PIP_VERSION)"
    fi
}

# Go
install_go() {
    eval "$(mise activate bash || true)"
    if ! command -v go >/dev/null 2>&1 || ! mise which go >/dev/null 2>&1;
        then
        echo "★ Go (managed by mise) is not installed. Installing the latest Go using mise..."
        mise use -g go@latest
        GO_VERSION=$(get_mise_tool_version go)
        echo "★ Go installation completed!! ($GO_VERSION)"
    else
        GO_VERSION=$(get_mise_tool_version go)
        echo "★ Go (managed by mise) is already installed. ($GO_VERSION)"
    fi
}

# Rust
install_rust() {
    eval "$(mise activate bash || true)"
    if ! command -v rustc >/dev/null 2>&1 || ! mise which rustc >/dev/null 2>&1;
        then
        echo "★ Rust (managed by mise) is not installed. Installing the latest Rust using mise..."
        mise use -g rust@latest
        RUST_VERSION=$(get_mise_tool_version rust)
        echo "★ Rust installation completed!! ($RUST_VERSION)"
    else
        RUST_VERSION=$(get_mise_tool_version rust)
        echo "★ Rust (managed by mise) is already installed. ($RUST_VERSION)"
    fi
}

# Lua
install_lua() {
    eval "$(mise activate bash || true)"
    if ! command -v lua >/dev/null 2>&1 || ! mise which lua >/dev/null 2>&1;
        then
        echo "★ Lua (managed by mise) is not installed. Installing the latest Lua using mise..."
        mise use -g lua@latest
        LUA_VERSION=$(get_mise_tool_version lua)
        echo "★ Lua installation completed!! ($LUA_VERSION)"
    else
        LUA_VERSION=$(get_mise_tool_version lua)
        echo "★ Lua (managed by mise) is already installed. ($LUA_VERSION)"
    fi
}

# Neovim
install_neovim() {
    eval "$(mise activate bash || true)"
    if ! command -v nvim >/dev/null 2>&1 || ! mise which nvim >/dev/null 2>&1;
        then
        echo "★ Neovim (managed by mise) is not installed. Installing Neovim using mise..."
        mise use -g neovim@latest
        NVIM_VERSION=$(get_mise_tool_version neovim)
        echo "★ Neovim installation completed!! ($NVIM_VERSION)"
    else
        NVIM_VERSION=$(get_mise_tool_version neovim)
        echo "★ Neovim (managed by mise) is already installed. ($NVIM_VERSION)"
    fi
}

# ghq
install_ghq() {
    eval "$(mise activate bash || true)"
    if ! command -v ghq >/dev/null 2>&1 || ! mise which ghq >/dev/null 2>&1;
        then
        echo "★ ghq (managed by mise) is not installed. Installing ghq using mise..."
        mise use -g ghq@latest
        echo "★ ghq installation completed!!"
    else
        echo "★ ghq (managed by mise) is already installed."
    fi
}

# --- OSパッケージ経由のツール ---

# PostgreSQL Client (psql)
install_psql() {
    if ! command -v psql >/dev/null 2>&1;
        then
        echo "★ psql is not installed. Installing postgresql-client..."
        sudo apt install -y postgresql-client
        PSQL_VERSION=$(psql --version 2>/dev/null || echo "version check failed")
        echo "★ psql installation completed!! ($PSQL_VERSION)"
    else
        PSQL_VERSION=$(psql --version 2>/dev/null || echo "version check failed")
        echo "★ psql is already installed. ($PSQL_VERSION)"
    fi
}

# SQLite3
install_sqlite3() {
    if ! command -v sqlite3 >/dev/null 2>&1;
        then
        echo "★ sqlite3 is not installed. Installing sqlite3..."
        sudo apt install -y sqlite3
        SQLITE_VERSION=$(sqlite3 --version 2>/dev/null || echo "version check failed")
        echo "★ sqlite3 installation completed!! ($SQLITE_VERSION)"
    else
        SQLITE_VERSION=$(sqlite3 --version 2>/dev/null || echo "version check failed")
        echo "★ sqlite3 is already installed. ($SQLITE_VERSION)"
    fi
}

# fzf (Fuzzy Finder) と依存関係
install_fzf() {
    if ! command -v fzf >/dev/null 2>&1;
        then
        echo "★ fzf is not installed. Installing fzf..."
        sudo apt install -y fzf
        install_bat
        install_fd
        echo "★ fzf installation completed!!"
    else
        echo "★ fzf is already installed."
        install_bat
        install_fd
    fi
}

# bat
install_bat() {
    # `bat` または `batcat` が存在しない場合
    if ! command -v bat >/dev/null 2>&1 && ! command -v batcat >/dev/null 2>&1;
        then
        echo "★ bat/batcat is not installed. Installing bat..."
        sudo apt install -y bat
        # batcat コマンドが存在し、かつ /usr/local/bin/bat が存在しない場合にシンボリックリンクを作成
        if command -v batcat >/dev/null 2>&1 && [ ! -e /usr/local/bin/bat ]; then
             echo "★ Creating symlink for batcat as bat in /usr/local/bin..."
             sudo ln -s $(which batcat) /usr/local/bin/bat || echo "Warn: Failed to create symlink for batcat." # エラーメッセージ変更
        fi
        echo "★ bat/batcat installation completed!!"
    else
        echo "★ bat/batcat is already installed."
    fi
}

# fd
install_fd() {
     # `fd` または `fdfind` が存在しない場合
    if ! command -v fd >/dev/null 2>&1 && ! command -v fdfind >/dev/null 2>&1;
        then
        echo "★ fd/fdfind is not installed. Installing fd-find..."
        sudo apt install -y fd-find
        # fdfind コマンドが存在し、かつ ~/.local/bin/fd が存在しない場合にシンボリックリンクを作成
        if command -v fdfind >/dev/null 2>&1 && [ ! -e "$HOME/.local/bin/fd" ]; then
             echo "★ Creating symlink for fdfind as fd in ~/.local/bin..."
             mkdir -p "$HOME/.local/bin" # ディレクトリが存在しない場合に作成
             ln -s $(which fdfind) "$HOME/.local/bin/fd" || echo "Warn: Failed to create symlink for fdfind." # エラーメッセージ変更
        fi
        echo "★ fd/fdfind installation completed!!"
    else
        echo "★ fd/fdfind is already installed."
    fi
}

# Fish Shell と Fisher
install_fish() {
    if ! command -v fish >/dev/null 2>&1;
        then
        echo "★ fish is not installed. Installing fish..."
        # UbuntuのPPAから最新安定版をインストール
        # sudo -E で環境変数引き継ぐ（プロキシ環境用）
        sudo -E apt-add-repository -y ppa:fish-shell/release-4
        sudo -E apt update -y
        sudo -E apt install -y fish
        FISH_VERSION=$(fish --version 2>/dev/null || echo "version check failed")
        echo "★ fish installation completed!! ($FISH_VERSION)"
        # fishインストール後にfisherをインストール
        install_fisher
    else
        FISH_VERSION=$(fish --version 2>/dev/null || echo "version check failed")
        echo "★ fish is already installed. ($FISH_VERSION)"
        # fishが既に存在する場合でもfisherとテーマのインストールは試みる
        install_fisher
    fi
}

# Fisher と bobthefish テーマ
install_fisher() {
    # fish コマンドが存在するか確認
    if ! command -v fish >/dev/null 2>&1;
        then
        echo "★ fish is not installed. Cannot install fisher."
        return 1 # エラーを示すステータスを返す
    fi

    # fishコマンド実行時のエラーはスクリプトを止めないようにする
    if ! fish -c "type -q fisher" > /dev/null 2>&1;
        then
        echo "★ Installing fisher (Fish plugin manager)..."
        # fisherのインストール（エラー発生時はメッセージ表示）
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" || echo "Error: Fisher installation failed."
        echo "★ fisher installation attempt completed!!"
    else
        echo "★ fisher is already installed."
    fi

    # bobthefish テーマがインストールされているか確認 (エラー発生時はメッセージ表示)
    if ! fish -c "fisher list 2>/dev/null | grep -q 'oh-my-fish/theme-bobthefish'";
         then
         echo "★ Installing bobthefish theme for fish..."
         fish -c "fisher install oh-my-fish/theme-bobthefish" || echo "Error: bobthefish installation failed."
         echo "★ bobthefish theme installation attempt completed!!"
    else
         echo "★ bobthefish theme is already installed."
    fi
}

# Docker Engine, CLI, Compose
install_docker() {
    if ! command -v docker >/dev/null 2>&1;
        then
        echo "★ docker is not installed. Installing docker..."
        # リポジトリ設定に必要なパッケージをインストール
        sudo apt-get update -y
        sudo apt-get install -y ca-certificates gnupg
        # Dockerの公式GPGキーを追加
        sudo install -m 0755 -d /etc/apt/keyrings
        if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            sudo chmod a+r /etc/apt/keyrings/docker.gpg
        fi
        # Dockerリポジトリを追加
        if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        fi
        # Docker Engineのインストール
        sudo apt-get update -y
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        # sudoなしでdockerコマンドを実行できるようにする
        if getent group docker > /dev/null;
            then
            echo "★ Adding current user ($USER) to the docker group..."
            sudo usermod -aG docker $USER || echo "Warn: Failed to add user to docker group." # グループ追加失敗は許容
            echo "★ Docker group membership updated. Please log out and log back in, or run 'newgrp docker' for this change to take effect in the current session."
        else
            echo "★ 'docker' group not found or could not be created/modified. Docker commands might require sudo."
        fi
        DOCKER_VERSION=$(docker --version 2>/dev/null || echo "version check failed")
        echo "★ docker installation completed!! ($DOCKER_VERSION)"
    else
        DOCKER_VERSION=$(docker --version 2>/dev/null || echo "version check failed")
        echo "★ docker is already installed. ($DOCKER_VERSION)"
         # dockerグループが存在し、ユーザーが所属していない場合は追加を試みる (冪等性)
         if getent group docker > /dev/null && ! groups $USER | grep -q '\bdocker\b'; then
            echo "★ Adding current user ($USER) to the docker group..."
            sudo usermod -aG docker $USER || echo "Warn: Failed to add user to docker group."
            echo "★ Docker group membership updated. Please log out and log back in, or run 'newgrp docker' for this change to take effect in the current session."
         fi
    fi
}

# --- Git リポジトリ管理 (ghq) ---

# ghq を使って指定されたリポジトリを取得 (SSH経由)
ghq_get() {
    REPO=$1
    eval "$(mise activate bash || true)"
    if ! command -v ghq >/dev/null 2>&1;
        then
        echo "★ Error: ghq command not found even after activating mise. Cannot run ghq_get."
        return 1
    fi

    GHQ_ROOT=$(ghq root 2>/dev/null || echo "$HOME/ghq")
    REPO_DIR="$GHQ_ROOT/github.com/$REPO"

    if [ ! -d "$REPO_DIR" ]; then
        echo "★ Cloning repository $REPO using ghq (via SSH)..."
        # ghq get のエラーは関数内でハンドリングせず呼び出し元に返す
        if ghq get -p "$REPO"; then
             echo "★ Repository cloned successfully to $REPO_DIR."
             return 0 # 成功
        else
             echo "★ Error: Failed to clone repository $REPO."
             return 1 # 失敗
        fi
    else
        echo "★ Repository $REPO already exists at $REPO_DIR."
        return 0 # 存在する場合も成功扱い
    fi
}

# bobthefish 用のカスタムカラー設定をインストール
install_bobthefish_colors_iceberg() {
    eval "$(mise activate bash || true)"
    if ! command -v fish >/dev/null 2>&1 || ! command -v ghq >/dev/null 2>&1;
        then
        if ! command -v fish >/dev/null 2>&1; then echo "★ Error: fish command not found."; fi
        if ! command -v ghq >/dev/null 2>&1; then echo "★ Error: ghq command not found (managed by mise)."; fi
        echo "★ Skipping bobthefish_colors setup due to missing dependencies."
        return 1
    fi

    # fishの設定ディレクトリを確認し、なければ作成
    CONFIG_DIR="$HOME/.config/fish/functions"
    mkdir -p "$CONFIG_DIR"

    COLORS_FILE="bobthefish_colors.fish"
    REPO="ngmtine/bobthefish_colors_iceberg"

    # bobthefish_colors.fish ファイルが設定ディレクトリに存在するか確認
    if [ ! -f "$CONFIG_DIR/$COLORS_FILE" ]; then
        echo "★ $COLORS_FILE is not found. Installing bobthefish_colors..."

        # リポジトリを取得 (ghq_get を使用, エラーがあれば中断)
        if ! ghq_get $REPO;
             then
             echo "★ Skipping bobthefish_colors setup because ghq get failed."
             return 1
        fi

        # ghq で取得したリポジトリのパスを取得
        GHQ_ROOT=$(ghq root 2>/dev/null || echo "$HOME/ghq")
        CLONE_DIR="$GHQ_ROOT/github.com/$REPO"

        # クローンされたファイルが存在するか確認
        if [ -f "$CLONE_DIR/$COLORS_FILE" ]; then
            # シンボリックリンクを作成
            ln -s "$CLONE_DIR/$COLORS_FILE" "$CONFIG_DIR/$COLORS_FILE" || echo "Warn: Failed to create symlink for $COLORS_FILE."
            echo "★ bobthefish_colors installation completed!!"
        else
             echo "★ Error: Cloned repository does not contain $COLORS_FILE. Looked in: $CLONE_DIR"
             return 1
        fi
    else
        echo "★ $COLORS_FILE is already installed."
    fi
}

# --- Dotfiles ---

# dotfilesリポジトリをクローンし、セットアップを実行
setup_dotfiles() {
    eval "$(mise activate bash || true)"
    if ! command -v ghq >/dev/null 2>&1; then
        echo "★ Error: ghq command not found. Skipping dotfiles setup."
        return 1
    fi

    echo "★ Cloning and setting up dotfiles repositories..."
    local dotfiles_repos=(
        "ngmtine/dotfiles"
        "ngmtine/dotfiles-nvim"
    )

    GHQ_ROOT=$(ghq root 2>/dev/null || echo "$HOME/ghq")

    for repo in "${dotfiles_repos[@]}"; do
        ___
        echo "★ Processing repository: $repo"
        if ! ghq_get "$repo"; then
            echo "★ Error: Failed to get repository $repo. Skipping setup for this repo."
            continue
        fi

        local repo_dir="$GHQ_ROOT/github.com/$repo"
        local install_script="$repo_dir/install.sh"

        if [ -f "$install_script" ]; then
            echo "★ Found install.sh. Running setup for $repo..."
            # install.sh をbashで実行
            (cd "$repo_dir" && bash "$install_script")
            echo "★ Setup for $repo completed."
        else
            echo "★ install.sh not found in $repo. Skipping automated setup."
        fi
    done
}

# --- メイン処理 ---

main() {
    echo "Starting Development Environment Setup..."
    start_time=$(date +%s)

    ___
    check_os
    DATE=$(date '+%Y/%m/%d %H:%M:%S')
    sudo echo "Starting package installation at ${DATE}..."
    apt_update

    ___
    install_mise

    # GitHub SSHセットアップ
    ___
    setup_github_ssh

    # 言語ランタイム & 主要ツール (mise経由)
    ___
    install_nodejs
    ___
    install_deno
    ___
    install_bun
    ___
    install_python
    ___
    install_go
    ___
    install_rust
    ___
    install_lua
    ___
    install_neovim
    ___
    install_ghq

    # OSパッケージ経由のツール
    ___
    install_psql
    ___
    install_sqlite3
    ___
    install_fzf
    ___
    install_fish
    ___
    install_docker

    # カスタマイズ
    ___
    # カスタマイズ関数の実行 (エラーが発生してもスクリプトは止めないように || true をつける)
    install_bobthefish_colors_iceberg || true
    setup_dotfiles || true

    ___

    # 終了処理
    end_time=$(date +%s)
    execution_time=$((end_time - start_time))

    echo "★ Development environment setup completed!"
    echo "★ Total execution time: ${execution_time} seconds"
    echo "============================================================"
    echo "IMPORTANT NEXT STEPS:"
    echo "1. Please restart your terminal or run 'source ~/.bashrc'"
    echo "   to ensure all environment changes (PATH, mise activate) are applied."
    if command -v fish >/dev/null 2>&1 && [[ "$SHELL" != *"fish"* ]]; then
        # which fish の結果を使う
        FISH_PATH=$(which fish)
        if [ -n "$FISH_PATH" ]; then
          echo "2. To set fish as your default shell, run: chsh -s $FISH_PATH"
            echo "   (You may need to log out and log back in for the change to take effect)."
        else
             echo "2. fish shell installed, but path not found. Cannot suggest chsh command."
        fi
    fi
    # dockerグループの確認と案内
    if id -nG "$USER" | grep -q '\bdocker\b'; then
        echo "3. You have been added to the 'docker' group. Log out and log back in,"
        echo "   or run 'newgrp docker' to use docker without sudo in the current session."
    elif command -v docker >/dev/null 2>&1;
         then
         echo "3. Docker is installed, but you might need sudo to run docker commands,"
         echo "   or add your user to the 'docker' group manually (requires logout/login)."
    fi
    echo "============================================================"
}

# スクリプトのメイン処理を実行
main
