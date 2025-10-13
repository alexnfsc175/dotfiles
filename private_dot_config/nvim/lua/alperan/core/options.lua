-- Define as opções do editor

-- Aparência
-- vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.guicursor = {
	"n-v-c-sm:block-Cursor/lCursor",
	"i-ci-ve:ver20-Cursor/lCursor",
	"r-cr-o:hor20-Cursor/lCursor",
}

-- vim.opt.guicursor = "a:blinkwait600-blinkoff450-blinkon500,sm:block-blinkwait175-blinkoff150-blinkon175"
-- vim.opt.guicursor:append("n-c:block-Cursor,v:block-CursorVisual,i-ci-ve:ver25-CursorInsert,r-cr:hor20,o:hor50")
vim.o.cursorline = true

vim.opt.nu = true -- Mostra números de linha # Added
vim.opt.number = true -- Mostra o número das linhas
vim.opt.relativenumber = false -- Mostra números de linha relativos
vim.opt.termguicolors = true -- Habilita cores de 24 bits
vim.opt.signcolumn = "yes" -- Sempre mostrar a coluna de sinais (para git, lsp, etc.)
vim.opt.wrap = false -- Desabilita quebra de linha

-- Indentação
vim.opt.expandtab = true -- Usa espaços em vez de tabs
vim.opt.tabstop = 4 -- Largura de um tab em espaços
vim.opt.softtabstop = 4 -- Número de espaços para tab/backspace
vim.opt.shiftwidth = 4 -- Número de espaços para auto-indentação
vim.opt.autoindent = true -- Mantém a indentação da linha anterior
vim.opt.smartindent = true -- Indentação inteligente para linguagens como C, C++, etc.

-- Busca
vim.opt.hlsearch = true -- Destaca os resultados da busca
vim.opt.incsearch = true -- Mostra resultados da busca enquanto digita
vim.opt.ignorecase = true -- Ignora maiúsculas/minúsculas na busca
vim.opt.smartcase = true -- A menos que a busca contenha uma letra maiúscula
vim.opt.inccommand = "split" -- Mostra resultados da substituição enquanto digita

vim.opt.ignorecase = true -- Ignora maiúsculas/minúsculas na busca # Added
vim.opt.smartcase = true -- A menos que a busca contenha uma letra maiúscula # Added
vim.opt.background = "dark" -- Define o fundo como escuro # Added

-- Outros
vim.opt.scrolloff = 8 -- Mantém 8 linhas de contexto acima/abaixo do cursor
vim.opt.undofile = true -- Habilita histórico de 'undo' persistente
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Diretório de histórico de 'undo'
vim.opt.backup = false -- Desabilita backups
vim.opt.swapfile = false -- Desabilita swapfiles

-- Performance # Added
vim.o.foldenable = true -- Habilita dobramento de código
vim.o.foldmethod = "manual" -- Método de dobramento baseado em indentação
vim.o.foldlevel = 99 -- Nível de dobramento padrão (99 para não dobrar nada)
vim.o.foldcolumn = "0" -- Desabilita a coluna de dobramento

-- Backspace # Added
vim.opt.backspace = { "start", "eol", "indent" } -- Permite backspace em qualquer lugar

-- Splits # Added
vim.opt.splitright = true -- Janelas verticais abrem à direita
vim.opt.splitbelow = true -- Janelas horizontais abrem abaixo

-- Performance # Added
vim.opt.isfname:append("@-@") -- Permite caracteres especiais em nomes de arquivos
vim.opt.updatetime = 50 -- Tempo de atualização
vim.opt.colorcolumn = "80" -- Coluna de cor [default:80]

-- Clipboard # Added
vim.opt.clipboard:append("unnamedplus") -- Usa o clipboard do sistema
vim.opt.hlsearch = true -- Destaca os resultados da busca
vim.opt.mouse = "a" -- Habilita o uso do mouse

vim.g.editorconfig = true -- Habilita suporte ao EditorConfig

-- Terminal
vim.o.shell = "/bin/zsh"
