# Current Neovim Config Reference (Pre-LazyVim Migration)

This document captures the important parts of your existing configuration so you can selectively port them into a new LazyVim starter setup.

---

## 1. Core Structure

- `init.lua` sets `mapleader`, bootstraps `lazy.nvim`, and loads `config.options`, `config.keymaps`, then `lazy.setup("plugins")`.

---

## 2. Global Options (`lua/config/options.lua`)

Editor UI & Behavior:

- `number`, `relativenumber`, `cursorline`, `signcolumn = "yes"`, `termguicolors = true`
- `mouse = "a"`, `clipboard = "unnamedplus"`, `wrap = false`
- `scrolloff = 8`, `sidescrolloff = 8`

Indentation Defaults:

- `tabstop = 4`, `shiftwidth = 4`, `expandtab = true`, `autoindent = true`, `smartindent = true`, `cindent = true`

Search:

- `ignorecase = true`, `smartcase = true`

Splits:

- `splitright = true`, `splitbelow = true`

Performance / UX:

- `updatetime = 250`, `timeoutlen = 300`

Custom Filetype Extensions:

- `ino -> arduino`
- `tsx -> typescriptreact`, `jsx -> javascriptreact`

Language‑specific indentation autocmd (for js/jsx/ts/tsx/json/html/css/lua):

- Sets local `tabstop = 2`, `shiftwidth = 2`, `cindent = true`, `smartindent = true`, forces `indentexpr = nvim_treesitter#indent()`.

---

## 3. Keymaps (`lua/config/keymaps.lua`)

General:

- `<leader>w` Save
- `<leader>q` Quit
- `<leader>nh` Clear search highlight

Navigation / Windows:

- `<C-h/j/k>` move between windows (intentionally no `<C-l>` to keep Copilot `<C-l>` in insert mode)
- `<C-d>` / `<C-u>` scroll half-page and center (`zz`)

Insert Mode:

- `jk` -> `<Esc>`

Diagnostics:

- `<leader>e` float
- `[d` / `]d` prev / next

LSP Core:

- `gd` definition
- `K` hover
- `<leader>rn` rename
- `<leader>ca` code action
- `<leader>li` LspInfo
- `<leader>lr` LspRestart

File Explorer:

- `<leader>fe` `:Ex`

Formatting:

- `<leader>cf` buffer format via `conform` (with `lsp_fallback = true`)

Git:

- `<leader>lg` LazyGit

Harpoon (in plugin config but notable):

- `<leader>a` add file
- `<leader>h` toggle menu
- `<leader>j/k/l/;` select slots 1–4
- `<C-S-P>` previous harpoon file
- `<C-S-N>` next harpoon file

Filetype-Specific Autocmd Keymaps:

- Arduino: `<leader>av` compile, `<leader>au` upload, `<leader>as` serial
- TypeScript/JavaScript: `<leader>to` organize imports, `<leader>ti` add missing imports, `<leader>tu` remove unused imports
- Go: `<leader>gt` tests, `<leader>gc` coverage

Telescope (declared in plugin spec `keys`):

- `<leader>ff` find files
- `<leader>fa` find all (hidden + no_ignore)
- `<leader>fg` live grep
- `<leader>fb` buffers
- `<leader>fh` help tags

Copilot:

- Insert `<C-l>` accept suggestion
- Insert `<C-j>` accept word (optional)

---

## 4. Plugins & Notable Configurations (`lua/plugins/*.lua`)

Below grouped by purpose.

### UI / Theme

- `catppuccin/nvim` (`name = catppuccin`, priority 1000)
  - `flavour = auto`; backgrounds map light->latte, dark->mocha
  - Integrations: cmp, telescope, treesitter

### Syntax / Treesitter

- `nvim-treesitter/nvim-treesitter`
  - `ensure_installed`: lua, vim, vimdoc, bash, python, javascript, typescript, tsx, json, html, css, go, c, cpp, arduino, svelte
  - `highlight.enable = true`, `indent.enable = true`

### Completion & Snippets

- `hrsh7th/nvim-cmp` + deps: `cmp-nvim-lsp`, `LuaSnip`, `cmp_luasnip`, `nvim-autopairs`
  - Mappings: `<C-b>/<C-f>` scroll docs; `<C-Space>` complete; `<C-e>` abort; `<CR>` confirm (select=true)
  - Navigation duplicates for arrows + `<C-n>/<C-p>`
  - Tab / Shift-Tab integrate with LuaSnip (jump/expand else fallback)
- `L3MON4D3/LuaSnip`
  - Custom Arduino snippets: `setup`, `pinMode`, `digitalRead`, `digitalWrite`, `print`, `println`

### Autopairs

- `windwp/nvim-autopairs`
  - `check_ts = true` with language-specific overrides
  - FastWrap `<M-e>`; custom characters set; integrated with cmp confirm

### LSP / Language Servers

- `neovim/nvim-lspconfig` (+ `cmp-nvim-lsp`, `b0o/schemastore.nvim`)
  - Global diagnostics: virtual_text, signs, underline, severity_sort, no update in insert
  - Common `on_attach`: disables formatting for `ts_ls`, `pyright`, `gopls`, `svelte`; enables inlay hints if supported
  - Servers:
    - `lua_ls`, `bashls` (basic)
    - `ts_ls` (typescript-language-server): extensive inlay hints for TS & JS
    - `pyright`: analysis `typeCheckingMode = basic`
    - `gopls`: `gofumpt = true`, placeholders, unimported completion, rich hints
    - `clangd`: custom cmd flags (`--background-index`, `--clang-tidy`, etc.), filetypes c/cpp/objc/objcpp, root detection skip `.ino`; adds `<leader>ch` to switch source/header
    - `jsonls`: attaches schemas from `schemastore`
    - `html`, `cssls`, `svelte`
    - `postgres_lsp` (SQL)

### Formatting

- `stevearc/conform.nvim`
  - `format_on_save`: timeout 500ms, fallback to LSP
  - `formatters_by_ft`:
    - python: isort, black
    - go: goimports, gofumpt
    - javascript / javascriptreact / typescript / typescriptreact / json / html / css / markdown / svelte: prettier
    - c / cpp / arduino: clang-format
    - sql: pg_format, sql-formatter
  - Custom `clang-format` uses external style file: `~/.config/nvim/.clang-format`

### Telescope

- `nvim-telescope/telescope.nvim` (branch 0.1.x)
  - Defaults: horizontal preview_width=0.6
  - `file_ignore_patterns`: %.git/, node_modules/, %.cache/
  - `find_files` picker: hidden=true; uses `rg --files --hidden --glob !**/.git/*`

### Harpoon

- `ThePrimeagen/harpoon` (branch harpoon2)
  - Basic setup with quick menu & navigation keymaps (see keymaps section)

### Git

- `kdheepak/lazygit.nvim` (commands only; lazy-loaded)

### Markdown Preview

- `iamcco/markdown-preview.nvim`
  - `build = "cd app && yarn install"`, `ft=markdown`, sets `g:mkdp_filetypes`

### Arduino

- `vim-scripts/Arduino-syntax-file`
  - Autocmd on `arduino` filetype: disables diagnostics (virtual text/signs/underline), sets `syntax=cpp`, defines user commands `ArduinoCompile`, `ArduinoUpload`, `ArduinoSerial`, plus notification on activation
  - Helper functions wrap `arduino-cli` compile/upload/monitor; assumes board fqbn `arduino:avr:uno` and serial device `/dev/cu.usbmodem*`

### Copilot

- `github/copilot.vim`
  - Disables default tab mapping via `g:copilot_no_tab_map = true`
  - `<C-l>` accept suggestion; `<C-j>` accept word

---

## 5. Formatting Tooling Details

`conform.nvim` ordering matters (e.g., Go: goimports then gofumpt). `clang-format` is pointed to a project style file; ensure to copy `.clang-format` into new config.

If migrating to LazyVim:

- Use LazyVim's built-in formatter (conform integration) or preserve this file by creating `lua/plugins/format.lua` override.
- Disable server formatting (already done) to avoid conflicts.

---

## 6. Language-Specific Enhancements

Arduino:

- Filetype extension mapping, syntax forced to C++, diagnostics suppressed, custom commands + keymaps + snippets.
  TypeScript/JavaScript:
- Inlay hints enabled; custom TSTools keymaps (requires `typescript-language-server` + external commands you used via `:TSTools*` if you add that plugin later — note: TSTools plugin itself isn't present; keymaps invoke commands presumably from `typescript-tools.nvim` or `nvim-treesitter` extras — verify after migration).
  Go:
- LSP tuned; test and coverage keymaps expect `:GoTest` / `:GoCoverage` (you do NOT currently declare a Go tooling plugin like `ray-x/go.nvim` or `fatih/vim-go`—these commands may come from an external plugin previously removed or not committed; note this for migration).
  SQL:
- `postgres_lsp` assumed installed binary `postgrestools`.

---

## 7. Snippets Summary (Arduino)

Trigger -> Expands To (placeholders abbreviated):

- `setup` -> skeleton with `Serial.begin(9600);` and loop stub
- `pinMode` -> `pinMode(<pin>, <MODE>);`
- `digitalRead` -> `digitalRead(<pin>)`
- `digitalWrite` -> `digitalWrite(<pin>, <LEVEL>);`
- `print` / `println` -> `Serial.print(…)` / `Serial.println(…)`

Copy these into LazyVim via a LuaSnip snippet file (`lua/snippets/arduino.lua`) or inline plugin config.

---

## 8. Potential Migration Checklist (LazyVim)

1. Copy option diffs that differ from LazyVim defaults (e.g., `scrolloff=8`, indentation overrides autocommand, Arduino & TSX/JSX filetypes additions).
2. Recreate keymaps not already provided by LazyVim (notably Arduino, Go, TSTools, Harpoon, Copilot acceptance `<C-l>`, `<leader>cf` if format mapping differs).
3. Add plugin specs for: Arduino syntax, conform config overrides, harpoon2, markdown preview, lazygit, autopairs custom fast_wrap, catppuccin theme (set as colorscheme), copilot, custom LuaSnip snippets.
4. Add LSP customizations: disable formatting for specified servers, enable inlay hints, clangd custom cmd & header switch map, jsonls schema integration.
5. Ensure external CLIs installed: `arduino-cli`, `typescript-language-server`, `pyright`, `gopls`, `clangd`, `postgrestools`, `rg`, `prettier`, `isort`, `black`, `goimports`, `gofumpt`, `pg_format`, `sql-formatter`.
6. Place `.clang-format` in new config root.

---

## 9. Missing / Implicit Tools Not Declared

- Commands `GoTest`, `GoCoverage`, `TSToolsOrganizeImports`, etc., come from plugins not present in current repo. If you rely on them, add the corresponding plugin(s) when migrating:
  - For Go: consider `ray-x/go.nvim` or `fatih/vim-go` (adjust keymaps)
  - For TS Tools: consider `pmizio/typescript-tools.nvim` or `jose-elias-alvarez/typescript.nvim`

---

## 10. Quick Reference Table

| Area                 | Key Items                                                                                |
| -------------------- | ---------------------------------------------------------------------------------------- |
| Theme                | catppuccin (auto flavour)                                                                |
| Completion           | nvim-cmp + LuaSnip + autopairs integration                                               |
| LSP Servers          | lua_ls, bashls, ts_ls, pyright, gopls, clangd, jsonls, html, cssls, svelte, postgres_lsp |
| Formatters (conform) | isort, black, goimports, gofumpt, prettier, clang-format, pg_format, sql-formatter       |
| Navigation           | Telescope, Harpoon                                                                       |
| Git                  | lazygit.nvim                                                                             |
| Markdown             | markdown-preview.nvim                                                                    |
| AI                   | github/copilot.vim                                                                       |
| Extra Lang           | Arduino syntax + custom commands                                                         |

---

## 11. Porting Snippets Into LazyVim (Example LuaSnip File)

Place in `lua/snippets/arduino.lua`:

```lua
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets('arduino', {
  s('setup', {
    t({'void setup() {','    Serial.begin(9600);','    '}), i(1,'// Setup code'), t({'','}','','void loop() {','    '}), i(2,'// Main code'), t({'','}'})
  }),
  s('pinMode', { t('pinMode('), i(1,'pin'), t(', '), i(2,'INPUT'), t(');') }),
  s('digitalRead', { t('digitalRead('), i(1,'pin'), t(')') }),
  s('digitalWrite', { t('digitalWrite('), i(1,'pin'), t(', '), i(2,'HIGH'), t(');') }),
  s('print', { t('Serial.print('), i(1,'value'), t(');') }),
  s('println', { t('Serial.println('), i(1,'value'), t(');') }),
})
```

---

## 12. Example LazyVim Plugin Override Snippet (Harpoon)

```lua
return {
  {
    'ThePrimeagen/harpoon', branch = 'harpoon2', dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup()
      local map = vim.keymap.set
      map('n','<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon add' })
      map('n','<leader>h', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
      map('n','<leader>j', function() harpoon:list():select(1) end)
      map('n','<leader>k', function() harpoon:list():select(2) end)
      map('n','<leader>l', function() harpoon:list():select(3) end)
      map('n','<leader>;', function() harpoon:list():select(4) end)
    end,
  },
}
```

---

## 13. External Dependencies Summary

Install (via Homebrew/npm/pip/etc.):

- Core: `ripgrep`, `node`, `python3`, `go`
- LSP servers: `typescript-language-server`, `pyright`, `gopls`, `clangd`
- Formatters: `black`, `isort`, `prettier`, `goimports`, `gofumpt`, `pg_format`, `sql-formatter`, `clang-format`
- Arduino: `arduino-cli`
- SQL: `postgrestools` (if using postgres_lsp)

---

## 14. Migration Tips

- Start LazyVim, open `:Lazy` to sync.
- Add plugin overrides incrementally; test after each group.
- Keep this file outside (or copy after reset) so it’s not erased by the reset.
- Recreate only what you still need—LazyVim already bundles many defaults (e.g., telescope, treesitter, cmp, lsp). Focus on deltas: Arduino, formatting specifics, inlay hint tuning, harpoon2 branch, Copilot bindings, custom snippets.

---

## 15. Fast Diff vs. Likely LazyVim Defaults

| Current                            | LazyVim Default? | Action                  |
| ---------------------------------- | ---------------- | ----------------------- |
| `scrolloff=8`                      | Often 0/4        | Reapply if desired      |
| Filetype extensions (ino/tsx/jsx)  | Not all          | Reapply                 |
| Treesitter list includes `arduino` | No               | Add to ensure_installed |
| Conform custom chain order         | Partially        | Port if needed          |
| Clangd extra flags                 | Not all          | Add override            |
| Inlay hints enabled by default     | Partially        | Ensure custom on_attach |
| Harpoon branch `harpoon2`          | No               | Add plugin spec         |
| Arduino CLI integration            | No               | Port plugin + keymaps   |
| Copilot `<C-l>` accept             | No               | Re-map                  |

---

## 16. Anything To Clean Up

- Missing plugin specs for commands `GoTest`, `GoCoverage`, `TSTools*`. Decide which plugin(s) to add or remove those keymaps.
- Consider consolidating language-specific formatters with LazyVim's format module if it duplicates.

---

End of reference.
