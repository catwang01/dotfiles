[TOC]

# Dotfiles

## Overview

This is a repository for bootstrapping your dotfiles with [Dotbot][dotbot].

## shell related

- `~/.bashrc -> bashrc`
- `~/.mybashrc -> shell/mybashrc`
    - This is used to place some genernal shell related information. 
    - We can put some general shell related configurations here and use the configurations for both login and non-login shell.
- `~/.zsh/my_zshrc.zsh -> .zsh/my_zshrc.zsh`
    - This is used to place some zshrc related information
- `~/.zsh/my_zshrc_local.zsh -> .zsh/my_zshrc_local.zsh`
    - This is used to place some zshrc related private information

## Scripts

For windows:

```bash
.\install.ps1 -c install.conf.win32.toml
```

Do not install:

```bash
.\install.ps1 -c install.conf.win32.toml --except crossplatform-shell
```

For Linux & MacOs:

```bash
./install -c install.conf.toml
```

Do not install:

```bash
./install -c install.conf.toml --except crossplatform-shell
```