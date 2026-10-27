# setup

開発環境の導入スクリプトと設定ファイルを管理します。設定は `config/`、実行スクリプトは `scripts/` にまとめています。

```text
config/
  alacritty/alacritty.toml
  tmux/tmux.conf
  nvim/
  codex/AGENTS.md
scripts/
  linux/
    install-tools.sh
    install-fish-addons.sh
    apply-nvim.sh
    get-nvim.sh
  windows/
    install-apps.ps1
    apply-nvim.ps1
    get-nvim.ps1
    apply-codex.ps1
```

`install-*` はソフトウェアの導入、`apply-*` は setup から利用先への設定の反映、`get-*` は利用先から setup への設定の取り込みに使います。Neovim の apply/get は引数なしで実行できます。以下のコマンドはリポジトリ直下から実行します。スクリプト内の設定パスは、実行時のカレントディレクトリに依存しません。

## Linux

Arch Linux・Fedora・Ubuntu の一般ユーザーで実行します。システムパッケージの操作時だけ sudo を使います。すべての `.sh` は Bash スクリプトです。

```bash
# システム更新と Git、curl、wget、unzip、Vim、tmux、fish、Neovim、uv の導入
bash scripts/linux/install-tools.sh

# Oh My Fish と Git プラグインの導入
bash scripts/linux/install-fish-addons.sh

# Neovim 設定の反映
bash scripts/linux/apply-nvim.sh

# 利用中の Neovim 設定を setup/config/nvim へ取り込む
bash scripts/linux/get-nvim.sh
```

コピーでは対象ファイルを上書きしますが、コピー先だけにあるファイルは削除しません。

この Neovim 設定は Neovim 0.12 以降が必要です。導入されたバージョンが古い場合は、別途 0.12 以降を導入してください。

## Windows

```powershell
# winget で導入するアプリの一覧
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install-apps.ps1 -ListOnly

# アプリを導入
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install-apps.ps1

# Neovim 設定を反映（-Destination で配置先を変更可能）
powershell -ExecutionPolicy Bypass -File .\scripts\windows\apply-nvim.ps1

# 利用中の Neovim 設定を setup/config/nvim へ取り込む（-Source で取得元を変更可能）
powershell -ExecutionPolicy Bypass -File .\scripts\windows\get-nvim.ps1

# Codex の共通指示と共有スキルを反映
powershell -ExecutionPolicy Bypass -File .\scripts\windows\apply-codex.ps1
```

アプリ導入ではインストール済みのバージョンを更新せず、個別に失敗しても残りを試した後に失敗したパッケージを報告します。

Neovim の apply/get は `init.lua`、`lazy-lock.json`、`lua/config/` と `lua/plugins/` 直下のファイルをコピーします。対象ファイルは上書きし、コピー先だけにあるファイルは削除しません。必須ファイルがない場合は、コピー先を変更する前に終了します。

Codex の共通指示は `config/codex/AGENTS.md` を編集し、変更後にスクリプトを再実行します。旧 `install-codex.ps1` で配置した管理対象ファイルも更新できます。管理対象外の既存 `AGENTS.md` は上書きしません。

共有スキルを追加する場合は `config/codex/skills/<name>/SKILL.md` を作成してスクリプトを再実行します。各スキルはジャンクションで接続されるため、接続後の編集はそのまま反映されます。無関係な既存スキルは保持します。

## 設定の反映先

| 設定 | 反映先 | 方法 |
| --- | --- | --- |
| Neovim（Linux） | `${XDG_CONFIG_HOME:-$HOME/.config}/nvim` | `apply-nvim.sh` |
| Neovim（Windows） | `%LOCALAPPDATA%\nvim` | `apply-nvim.ps1` |
| Codex 共通指示（Windows） | `$CODEX_HOME/AGENTS.md`、未指定時は `$HOME/.codex/AGENTS.md` | `apply-codex.ps1` |
| Codex 共有スキル（Windows） | `$HOME/.agents/skills/<name>` | `apply-codex.ps1` |
| tmux | `~/.tmux.conf` | `config/tmux/tmux.conf` を手動配置 |
| Alacritty | 利用環境の Alacritty 設定先 | `config/alacritty/alacritty.toml` を手動配置 |
| MCP | リポジトリ直下の `.mcp.json` | ルートに維持 |

Neovim の `get-nvim.sh` / `get-nvim.ps1` は、上記の利用先から `config/nvim/` へ逆方向にコピーします。

## Neovim 設定

- `init.lua`：基本設定とプラグイン管理を順番に読み込みます。
- `lua/config/`：オプション、基本キー操作、自動コマンド、lazy.nvim の起動処理です。
- `lua/plugins/`：LSP、補完、Treesitter、ターミナル、UI、ファイル操作、検索を機能別に設定します。
- `lazy-lock.json`：プラグインのコミットを固定します。別 PC への反映後は `:Lazy restore` で固定バージョンにそろえます。プラグインを更新したら `get-nvim` で lockfile も取り込みます。

初回起動時はプラグイン、Lua 言語サーバー、Treesitter パーサーを取得するためネットワーク接続が必要です。Treesitter の `main` ブランチを使うため、`tree-sitter` CLI 0.26.1 以降、C コンパイラー、`tar`、`curl` も用意してください。Telescope の全文検索には `rg` が必要です。

Mason は `lua_ls` を自動導入し、Mason で導入済みの他の LSP サーバーも自動で有効化します。StyLua は CLI として使い、旧バージョンの `--lsp` 非対応エラーや Lua の整形機能の重複を避けるため、LSP の自動有効化から除外します。自動導入するサーバーは `lua/plugins/lsp.lua` の `ensure_installed` に追加できます。Treesitter は C、Lua、Markdown、query、Vim、vimdoc のパーサーを導入し、利用可能なパーサーがあるファイルでハイライトを有効にします。

補完は nvim-cmp に統一し、LSP、vsnip、バッファー、コマンドラインと、Git コミット用の Git ソースを使います。`<C-Space>` で補完、`<C-p>` / `<C-n>` で候補移動、`<CR>` で確定します。

LSP の操作はサーバーが接続したバッファーだけに設定します。`gd` / `gD` は定義 / 宣言、`grr` は参照、`gri` は実装、`gh` はドキュメント、`<Space>ca` はコードアクション、`<Space>rn` はリネーム、`<Space>cf` は整形です。標準の `gf` などは上書きしません。

`<C-e>` はファイルツリー、`tt` / `tv` / `th` はタブ / 縦 / 横のターミナルを開閉します。Lua の編集はスペース 2 個にそろえます。リポジトリの Lua ファイルも `.stylua.toml` で同じ形式に整形します。

Alacritty が参照する carbonfox テーマと CommitMono Nerd Font は別途用意してください。MCP の GitHub 接続には環境変数 `GITHUB_PAT` を使用します。
