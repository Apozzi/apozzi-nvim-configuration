return {
  'lewis6991/gitsigns.nvim',
  config = function()
    vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = '#71467e', italic = true }) 

    require('gitsigns').setup({
      -- Configurações padrão que vêm ativas
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signcolumn = true,  -- Mostrar sinais na coluna de sinais
      numhl = false,      -- Destacar números de linha
      linehl = false,     -- Destacar linha inteira
      word_diff = false,  -- Mostrar diferenças de palavra em linha
      watch_gitdir = {
        follow_files = true
      },
      auto_attach = true,  -- Anexar automaticamente a buffers com arquivos git
      attach_to_untracked = true,
      current_line_blame = true, -- Ativa blame na linha atual
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- Mostra no final da linha
        delay = 100, -- Aparece rapidamente (milissegundos)
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '-- <author>, <author_time:%Y-%m-%d> - <summary>'
    })
  end,
  event = { 'BufReadPre', 'BufNewFile' },  -- Carregar antes de ler arquivo
}