local function on_attach_change(bufnr)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.opt.termguicolors = true
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { 
                desc = "nvim-tree: " .. desc,
                buffer = bufnr,
                noremap = true,
                silent = true,
                nowait = true
            }
    end

    api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', '<C-P>', function() api.tree.toggle{file_path = true} end, opts("Toggle nvimtree"))
end

return {
    {
        "nvim-tree/nvim-tree.lua",
        opts = { on_attach = on_attach_change }
    }
}
