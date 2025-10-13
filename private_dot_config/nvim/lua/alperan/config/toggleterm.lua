local utils = require("alperan.core.utils")

-- Configurações do toggleterm

return {
  -- Tamanho do terminal (pode ser um número de linhas ou uma porcentagem em string)
  size = 30,

  -- Abre o terminal no modo de inserção
  start_in_insert = true,

  -- Usa o shell definido nas configurações do Neovim (que será 'zsh' do nosso Containerfile)
  shell = vim.o.shell,

  -- Direção padrão do terminal (horizontal, vertical, float, tab)
  direction = 'horizontal',

  -- Fecha o terminal quando o processo dentro dele terminar
  close_on_exit = true,

  -- Mantém o tamanho se você redimensionar a janela do Neovim
  persist_size = true,

  -- Deixa os terminais inativos com um sombreamento, para focar no que é importante
  shade_terminals = true,
}


-- return {
--   direction = 'float',

--   -- Fecha o terminal quando o processo dentro dele terminar
--   close_on_exit = true,

--   -- Deixa os terminais inativos com um sombreamento
--   shade_terminals = true,

--   -- Abre o terminal no modo de inserção
--   start_in_insert = true,

--   -- Configurações para o terminal flutuante
--   float_opts = {
--     -- Borda apenas na parte superior para separar do código
--     border = 'single',

--     -- A mágica acontece aqui, usando funções para cálculo dinâmico

--     width = function()
--       -- A largura do terminal será a largura total da tela MENOS a largura do nvim-tree
--       local tree_width = utils.get_nvim_tree_width()
--       if tree_width > 0 then
--         -- CORREÇÃO: Subtraímos a largura da árvore E a largura da divisória (1 coluna)
--         return vim.o.columns - tree_width - 1
--       else
--         -- Se a árvore estiver fechada, ocupamos a largura total
--         return vim.o.columns
--       end
--     end,

--     height = function()
--       -- Vamos definir uma altura de 30% da tela
--       return math.floor(vim.o.lines * 0.3)
--     end,

--     col = function()
--       -- A coluna inicial do terminal é a largura do nvim-tree.
--       -- Se nvim-tree estiver fechado, a largura é 0, e o terminal começa na coluna 0.
--       local tree_width = utils.get_nvim_tree_width()
--       if tree_width > 0 then
--         -- CORREÇÃO: A coluna inicial é a largura da árvore MAIS a divisória (1 coluna)
--         return tree_width + 1
--       else
--         -- Se a árvore estiver fechada, a coluna inicial é 0
--         return 0
--       end
--     end,

--     row = function()
--       -- A linha inicial é calculada para que o terminal fique ancorado na parte inferior.
--       return vim.o.lines - math.floor(vim.o.lines * 0.3)
--     end,
--   },
-- }
