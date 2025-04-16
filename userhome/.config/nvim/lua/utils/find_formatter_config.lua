-- 設定ファイルを現在のディレクトリから親ディレクトリに向かって検索
-- @param filenames (string|table) 検索するファイル名のリストまたは単一ファイル名
-- @param bufnr (number, optional) 対象のバッファ番号
-- @return boolean 設定ファイルが見つかったかどうか
function find_formatter_config(filenames, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local buf_path = vim.api.nvim_buf_get_name(bufnr)
    local start_dir

    if buf_path and buf_path ~= "" then
        -- 開いているバッファのパスを開始点とする
        start_dir = vim.fn.fnamemodify(buf_path, ":h")
    else
        -- バッファが無ければcwdを開始点とする（nvimを引数なしで起動した場合）
        start_dir = vim.fn.getcwd()
    end

    if not start_dir then
        return false
    end

    if type(filenames) == "string" then
        filenames = { filenames }
    end

    -- 親方向に向かって探索
    local found_files = vim.fs.find(filenames, {
        path = start_dir,
        upward = true,
        limit = 1,
        type = "file"
    })

    return #found_files > 0
end

return find_formatter_config
