Forked from [ChristianChiarulli's dotfiles](https://github.com/Mach-OS/Machfiles/)

![2022-04-27_22-47](https://user-images.githubusercontent.com/39678448/165678794-9971b3f0-041c-49ae-bdd3-26d12b329b80.png)

## Installing

You will need `git` and GNU `stow`

Clone into your `$HOME` directory or `~`

```bash
git clone https://github.com/liraymond04/.dotfiles.git ~
```

Run `stow` to symlink everything or just select what you want

```bash
stow */ # Everything (the '/' ignores the README)
```

```bash
stow zsh # Just my zsh config
```
