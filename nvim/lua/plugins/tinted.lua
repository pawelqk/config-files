local M = {
    "tinted-theming/tinted-vim",
    lazy = false, -- load at start
    priority = 1000, -- load first
}

function M.config() 
    --vim.cmd([[colorscheme base16-windows-95]])
    vim.cmd([[colorscheme base24-ayu-dark]])
    vim.o.background = "dark"
    -- Make comments more prominent -- they are important.
    local bools = vim.api.nvim_get_hl(0, { name = "Boolean" })
    vim.api.nvim_set_hl(0, "Comment", bools)
    -- Make it clearly visible which argument we're at.
    local marked = vim.api.nvim_get_hl(0, { name = "PMenu" })
    vim.api.nvim_set_hl(
        0,
        "LspSignatureActiveParameter",
        { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true }
    )
    -- Make line numbers also more visible
    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='gray', bold=true })
    vim.api.nvim_set_hl(0, 'LineNr', { fg='white', bold=true })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='gray', bold=true })
end

return M
