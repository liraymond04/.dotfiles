# nvim

My personal [neovim](https://github.com/neovim/neovim) configuration

Used as a submodule in my main [dotfiles](https://github.com/liraymond04/.dotfiles) repository

## Structure

Document points of interest in config file structure

```
nvim/               // root
├─ lua/
│  ├─ core/         // main vim configs
│  ├─ plugins/
│  ├─ utils/
├─ init.lua         // entry point
```

### core

 - init.lua - loads in user options and handles basic flow
 - autocommands.lua - creates autocommands and augroups
 - keymaps.lua - user defined key mappings
 - options.lua - user defined vim options
 - plugins.lua - plugin install and setup

### plugins

Contains plugin configurations and setup, each lua file in this directory
is automatically included by lazy.nvim and has their setup functions run,
so configuration and setup should refer to the [lazy.nvim docs](https://lazy.folke.io/spec) for support.

Lua files in this directory just return tables where each table entry is a
plugin entry that is loaded by lazy.nvim, and so the Lua file names are not
important for anything other than organization and categorization.

A basic template Lua file that contains no plugins should return just an empty table,

```lua
-- nvim/lua/plugins/example.lua
return {
  
}
```

And any plugin can have their setup specified by adding it as a plugin entry,

```lua
-- nvim/lua/plugins/example.lua
return {
  { -- example entry
    "[author]/[repo-name]",
    opts = {
      -- opts go here
    },
  },
  -- add as many plugins as you want
}
```

### utils

Contains utility functions not part of plugin setup
 
## Tips

 - Commenting out the `requires "core"` in the root `init.lua` disables the configuration (same as using unconfigured Neovim)
 - Commenting out `requires "core.plugins"` in `core/init.lua` disables user installed plugins
 - Individual plugins can be disabled by commenting out their plugin entries in the `plugins` Lua files

## Setup

### Arch Linux

Install `nvim` and `make`

```bash
sudo pacman -S nvim make
```

If copy and paste doesn't work, install `xsel`

```bash
sudo pacman -S xsel
```

Open Neovim with the `nvim` command

```bash
nvim
```

Plugins, language servers, and treesitter parsers should be installed when entering `nvim` for the first time (may need a restart after installation is complete)
