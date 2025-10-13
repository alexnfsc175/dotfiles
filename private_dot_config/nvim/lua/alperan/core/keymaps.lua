local opts = { noremap = true, silent = true }

-- Define a tecla líder ANTES de carregar o lazy.nvim
-- A tecla espaço é uma escolha popular e ergonômica.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Atalho para sair do modo de inserção mais rápido
vim.keymap.set("i", "jk", "<ESC>", { desc = "Sair do modo de Inserção" })

-- Navegação entre janelas (splits)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Mover para janela à esquerda" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Mover para janela abaixo" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Mover para janela acima" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Mover para janela à direita" })

-- Atalho para salvar
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Salvar arquivo" })

-- Atalho para fechar o buffer
-- vim.keymap.set("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "Fechar buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Fechar buffer (delete)" })

-- Atalho para o explorador de arquivos (será configurado no plugin)
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Abrir explorador de arquivos" })

-- Atalhos para o Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Buscar arquivos" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Buscar por texto (Grep)" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buscar em buffers abertos" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Buscar na ajuda do Neovim" })

-- Atalhos para gestão de Buffers (as "abas" de arquivos)
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Próximo buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
-- Lembre-se que <leader>q já fecha um buffer (:bdelete)

-- Atalhos para gestão de Tabs (os "workspaces")
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "Nova aba (workspace)" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Fechar aba atual" })
vim.keymap.set("n", "gt", "<cmd>tabnext<CR>", { desc = "Próxima aba" })
vim.keymap.set("n", "gT", "<cmd>tabprevious<CR>", { desc = "Aba anterior" })

-- Atalhos para gestão de Buffers (as "abas" de arquivos)
vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Fechar buffers à direita" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Fechar buffers à esquerda" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Fechar outros buffers" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePickClose<cr>", { desc = "Selecionar e fechar buffer (pick)" })

-- Atalhos para o Terminal (toggleterm)
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Abrir/Fechar terminal principal" })
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Abrir terminal flutuante" })
vim.keymap.set(
	"n",
	"<leader>tv",
	"<cmd>ToggleTerm direction=vertical size=80<cr>",
	{ desc = "Abrir terminal vertical" }
)
-- Mapeamentos para o Modo Terminal
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "Sair do modo Terminal" })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Sair do modo Terminal com jk" })

-- Atalhos para redimensionar janelas (splits)
-- Usamos <cmd> para executar comandos do modo de comando e silent=true para não mostrar o comando na barra.
-- Aumenta/diminui a altura
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { silent = true, desc = "Aumentar altura da janela" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { silent = true, desc = "Diminuir altura da janela" })

-- Aumenta/diminui a largura
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<CR>", { silent = true, desc = "Aumentar largura da janela" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<CR>", { silent = true, desc = "Diminuir largura da janela" })

-- Mover Linhas
vim.keymap.set("n", "<A-k>", "<cmd>m -2<cr>==", { desc = "Move line Up" })
vim.keymap.set("n", "<A-j>", "<cmd>m +1<cr>==", { desc = "Move line Down" })
vim.keymap.set("v", "<A-k>", "<cmd>m '<-2<cr>gv=gv", { desc = "Move line Up" })
vim.keymap.set("v", "<A-j>", "<cmd>m '>+1<cr>gv=gv", { desc = "Move line Down" })
vim.keymap.set("x", "<A-k>", "<cmd>m '<-2<cr>gv-gv", { desc = "Move line Up" })
vim.keymap.set("x", "<A-j>", "<cmd>m '>+1<cr>gv-gv", { desc = "Move line Down" })

-- Snaks keymaps
vim.keymap.set("n", "<leader>sf", ":lua Snacks.scratch()<cr>", { silent = true, desc = "Toggle Scratch Buffer" })
vim.keymap.set("n", "<leader>S", ":lua Snacks.scratch.select()<cr>", { silent = true, desc = "Select Scratch Buffer" })
vim.keymap.set("n", "<leader>gl", ":lua Snacks.lazygit.log_file()<cr>", { silent = true, desc = "Lazygit Log (cwd)" })
vim.keymap.set("n", "<leader>lg", ":lua Snacks.lazygit()<cr>", { silent = true, desc = "Lazygit" })

-- LazyGit
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Abrir LazyGit" })

-- Os atalhos de busca (picker) foram removidos para evitar conflito com o Telescope.
-- Use os atalhos do Telescope (<leader>ff, <leader>fg, etc.)
-- vim.keymap.set("n", "<leader><leader>", ":lua Snacks.picker.recent()",      {silent = true, desc = "Recent Files" })
-- vim.keymap.set("n", "<leader>fb",       ":lua Snacks.picker.buffers()",     {silent = true, desc = "Buffers" })
-- vim.keymap.set("n", "<leader>fg",       ":lua Snacks.picker.grep()",        {silent = true, desc = "Grep Files" })
-- vim.keymap.set("n", "<C-n>",            ":lua Snacks.explorer()",           {silent = true, desc = "Explorer" })

vim.keymap.set(
	"n",
	"<leader>un",
	':lua require("alperan.core.utils").toggle_relative_number()<cr>',
	{ silent = true, desc = "Toggle line number mode" }
)

-- Recarrega a configuracao principal do Neovim
vim.keymap.set(
	"n",
	"<leader>r",
	":source ~/.config/nvim/init.lua<cr>",
	{ noremap = true, silent = true, desc = "Recarregar config do Neovim" }
)
