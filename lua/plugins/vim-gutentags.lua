return {
  "ludovicchabant/vim-gutentags",
  config = function()
    vim.g.gutentags_ctags_tagfile = "tags"
    vim.g.gutentags_modules = { "ctags" }
  end,
}