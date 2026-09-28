# setup

Arch Linux・Fedora・Ubuntu の一般ユーザーで `./setup.sh` を実行すると、システムパッケージを更新し、必要なパッケージと uv を導入します。システムパッケージの操作時だけ sudo を使います。fish の追加設定は `./fish.sh` で実行します。すべての `.sh` は Bash スクリプトです。

Neovim 設定は `./nvim.sh copy` で `${XDG_CONFIG_HOME:-$HOME/.config}/nvim` にコピーします。現在の設定をリポジトリへ戻す場合は `./nvim.sh copy --reverse`（短縮形は `-r`）、差分を見る場合は `./nvim.sh diff` を使います。`diff` は差分があると終了コード 1 を返します。

この Neovim 設定は `vim.lsp.enable()` を使うため Neovim 0.11 以降が必要です。Ubuntu 24.04 の標準パッケージは 0.9 系なので、設定を使う場合は別途 0.11 以降を導入してください。

## Codex

Edit `codex/AGENTS.md` and add shared skills under `codex/skills/<name>/SKILL.md`.
On Windows, run `powershell -ExecutionPolicy Bypass -File .\install-codex.ps1` from this directory.
The script copies the shared instructions and links each skill into Codex's user locations.
Run it again after changing `codex/AGENTS.md`; skill edits take effect through the links.
It leaves unrelated existing files and skills in place.

## Neovim

Run `powershell -ExecutionPolicy Bypass -File .\install-nvim.ps1` from this directory
to copy the tracked Neovim configuration into `%LOCALAPPDATA%\nvim`.
The script keeps local files such as `lazy-lock.json`.
