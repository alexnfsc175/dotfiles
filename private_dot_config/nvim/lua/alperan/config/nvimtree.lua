--- Configuração do NvimTree
--- Esta configuração define o comportamento do NvimTree, um explorador de arquivos para Neovim.
--- Ele permite a navegação entre arquivos e pastas, com várias opções de personalização.
--- @module 'alperan.config.nvimtree'
local BaseConfig = require("alperan.config.base-config")
local NvimTree = BaseConfig.new()

-- -- Carrega os módulos necessários no topo do arquivo para melhor organização e performance.
-- local nvim_tree = require("nvim-tree")

---Configura o NvimTree
---@return nil
function NvimTree.config()
	local nvim_tree = NvimTree:require_once("nvim-tree")

	-- Desabilitar netrw, o explorador de arquivos padrão do vim, para garantir que nvim-tree seja o padrão
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	nvim_tree.setup({
		-- O explorador NÃO se fechará ao abrir um arquivo
		actions = {
			open_file = {
				quit_on_open = false,
				resize_window = true, -- Redimensiona a janela para o tamanho do arquivo aberto
			},
		},
		-- Atualiza o foco para o arquivo aberto
		update_focused_file = {
			enable = true,
			update_cwd = true,
		},
		-- Filtros para não mostrar arquivos indesejados
		filters = {
			dotfiles = true, -- esconde arquivos como .gitconfig, .env
			custom = { ".git", "node_modules", ".cache" },
		},

		-- Habilita ícones para arquivos e pastas
		renderer = {
			indent_markers = {
				enable = false, -- Desabilita os marcadores de indentação
			},
		},
		-- Define a largura da barra lateral
		view = {
			width = 40,
			side = "left",
		},
		-- Desabilita a atualização automática do CWD (diretório de trabalho)
		-- Isso evita que o CWD mude para a pasta do arquivo aberto, o que pode ser confuso
		update_cwd = false,
	})
end

return NvimTree
