local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local nvim_cmp = require("plugins_cli/nvim-cmp")

-- config.yml の存在をチェック
-- vim起動ディレクトリ直下にlspconfig.ymlがある場合はそれを使う
-- NOTE: デフォはconfig.ymlみたいだけど紛らわしいのでlspconfig.ymlを指定
local sqls_cmd = { "sqls" }
local config_path = vim.fn.expand("$HOME/.config/sqls/lspconfig.yml")
if vim.fn.filereadable(config_path) == 1 then
    sqls_cmd = { "sqls", "-config", config_path }
end

-- lsp設定
lspconfig["sqls"].setup({
    on_attach = function(client, bufnr)
        -- sqlsのフォーマット機能は無効
        client.server_capabilities.documentFormattingProvider = false

        -- format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("sqlsFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                if vim.g.isFormatting then
                    vim.lsp.buf.format({ bufnr = bufnr })
                end
            end,
        })
    end,

    -- 補完
    capabilities = nvim_cmp,

    -- sql起動 lspconfig.ymlのある場合は引数で指定して起動
    cmd = sqls_cmd,
})

-- sql-formatter設定
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.sql_formatter.with({
            command = "sql-formatter",
            args = {
                "--config",
                "{ 'keywordCase': 'upper', 'tabWidth': 4, 'expressionWidth': 120 }",
            },
        }),
    },
})

--[[

https://github.com/sqls-server/sqls

# config.ymlについて
上から優先順位順に適用される

1. -config フラグで指定された構成ファイル
2. LSPクライアントに設定された workspace/configuration
3. 以下の場所にある構成ファイル
    $XDG_CONFIG_HOME/sqls/config.yml （$XDG_CONFIG_HOME が設定されていない場合は $HOME/.config が使用されます）

# config.ymlの例

```yaml
# Set to true to use lowercase keywords instead of uppercase.
lowercaseKeywords: false
connections:
  - alias: dsn_mysql
    driver: mysql
    dataSourceName: root:root@tcp(127.0.0.1:13306)/world
  - alias: individual_mysql
    driver: mysql
    proto: tcp
    user: root
    passwd: root
    host: 127.0.0.1
    port: 13306
    dbName: world
    params:
      autocommit: "true"
      tls: skip-verify
  - alias: mysql_via_ssh
    driver: mysql
    proto: tcp
    user: admin
    passwd: Q+ACgv12ABx/
    host: 192.168.121.163
    port: 3306
    dbName: world
    sshConfig:
      host: 192.168.121.168
      port: 22
      user: sshuser
      passPhrase: ssspass
      privateKey: /home/sqls-server/.ssh/id_rsa
  - alias: dsn_vertica
    driver: vertica
    dataSourceName: vertica://user:pass@host:5433/dbname
```

]]
