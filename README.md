Desktop specific dotfiles for Arch linux

## Installing

You will need `git` and GNU `stow`

Clone into your `$HOME` directory or `~` with submodules

```bash
git clone --recurse-submodules https://github.com/liraymond04/.dotfiles.git ~
```

And update submodules for existing repo

```bash
git submodule update --init --recursive
```

Run `stow` to symlink everything or just select what you want

```bash
stow */ # Everything (the '/' ignores the README)
```

```bash
stow zsh # Just my zsh config
```
