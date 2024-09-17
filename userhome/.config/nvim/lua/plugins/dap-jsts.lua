local dap = require('dap')

-- 開いているファイルを実行中であるnodeプロセスを探す
local function pick_node_process()
    local output = vim.fn.systemlist("ps -ax | grep 'node'")
    local filename = vim.fn.expand('%:p') -- 現在開いているファイルの絶対パス

    -- `node`, `--inspect`, `${file}` が含まれているプロセスを探す
    for _, line in ipairs(output) do
        if line:match('node') and line:match('--inspect') and line:match(vim.fn.escape(filename, '/')) then
            local pid = line:match("%s*(%d+)%s+.*")
            if pid then
                return pid
            end
        end
    end

    -- 対象プロセスが見つからなかった場合、手動で選択
    -- return require('dap.utils').pick_process()
    -- FIXME: 上記だとpidが取得できた場合でもなぜか必ず手動選択が実行される、原因不明なので一旦nil
    return nil
end

-- node-debug2-adapterの設定
dap.adapters.node = {
    type = 'executable',
    command = 'node',
    args = { os.getenv('HOME') .. '/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
}

-- jsデバッグ設定
dap.configurations.javascript = {
    {
        name = 'Launch js',
        type = 'node',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
    },
    {
        -- プロセスアタッチにはnodeを`--inspect`フラグつきで起動しておくこと
        name = 'Attach js',
        type = 'node',
        request = 'attach',
        -- processId = require 'dap.utils'.pick_process, -- 手動でプロセスを選択
        -- processId = function() return require('dap.utils').pick_process({ filter = "node" }) end, -- 手動でプロセスを選択（nodeでフィルタ）
        processId = pick_node_process, -- 自動でプロセスを選択
    },
}

-- tsデバッグ設定
dap.configurations.typescript = {
    {
        -- ts-nodeで実行（要 npm i -D -g ts-node）
        name = "Launch ts (ts-node)",
        type = "node",
        request = "launch",
        runtimeExecutable = "node",
        runtimeArgs = { "-r", "ts-node/register" },
        args = { "--inspect", "${file}" },
        skipFiles = { "node_modules/**" },
    },
    {
        -- `--inspect`で実行中のnodeプロセスにアタッチ（例 ts-node-dev --inspect=0.0.0.0:9229 hoge.ts）
        name = "Attach ts",
        type = "node",
        request = "attach",
    },
}
