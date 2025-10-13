--- Configuração do LSP para o Neovim
--- @module 'alperan.config.lsp'

local BaseConfig = require("alperan.config.base-config")
local LSP = BaseConfig.new()

--- Configura o LSP
---
---@return nil
function LSP.config()
	local lspconfig = LSP:require_once("lspconfig")
	local mason_config = LSP:require_once("mason-lspconfig")
	local cmp_nvim_lsp = LSP:require_once("cmp_nvim_lsp")
	local mason_tool = LSP:require_once("mason-tool-installer")

	-- Configuração visual para os diagnósticos do LSP (forma moderna e recomendada)
	local signs = {
		[vim.diagnostic.severity.ERROR] = " ",
		[vim.diagnostic.severity.WARN] = " ",
		[vim.diagnostic.severity.HINT] = "󰠠 ",
		[vim.diagnostic.severity.INFO] = " ",
	}

	vim.diagnostic.config({
		signs = {
			text = signs,
		},
		virtual_text = true,
		underline = true,
		update_in_insert = false,
	})

	-- Adiciona atalhos de teclado quando um servidor LSP é anexado a um buffer
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				local opts = { buffer = event.buf, desc = "LSP: " .. desc }
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, opts)
			end

			-- Atalhos para funcionalidades do LSP
			map("K", vim.lsp.buf.hover, "Mostrar documentação (Hover)")
			map("gd", vim.lsp.buf.definition, "Ir para definição")
			map("gr", "<cmd>Telescope lsp_references<CR>", "Ver referências")
			map("<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
			map("<leader>ca", vim.lsp.buf.code_action, "Ver ações de código disponíveis", { "n", "v" })
			map("<leader>d", vim.diagnostic.open_float, "Mostrar diagnósticos da linha")
			map("[d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, "Ir para o próximo diagnóstico")
			map("]d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, "Ir para o diagnóstico anterior")

			-- o autocomando abaixo é usado para destacar referências do documento
			-- quando o cursor estiver parado por um tempo.
			-- Veja `:help CursorHold` para informações sobre quando isso é executado.
			-- Quando você move o cursor, os destaques serão limpos (o segundo autocomando).
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
				local highlight_augroup = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("UserLspDetach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "UserLspHighlight", buffer = event2.buf })
					end,
				})
			end

			-- o código abaixo cria um keymap para alternar dicas de inserção no seu
			-- código, se o servidor de linguagem que você está usando suportar
			if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
				map("<leader>th", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, "[T]oggle Inlay [H]ints")
			end
		end,
	})

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())

	local servers = {
		-- Configurações específicas para cada servidor
		lua_ls = {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" }, -- Adiciona 'vim' como uma variável global
						disable = {
							"duplicate-set-field",
							"duplicate-doc-field",
						},
					},
					completion = {
						callSnippet = "Replace", -- Substitui o snippet de chamada
					},
					hint = {
						enable = true, -- Habilita dicas de tipo
						paramName = "Literal", -- Exibe o nome do parâmetro como dica
						arrayIndex = "Disable",
					},
				},
			},
			on_attach = function(client, bufnr)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
						return
					end
				end

				if client:supports_method("textDocument/inlayHint", { bufnr = bufnr }) then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end

				local nvim_settings = {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							[vim.fn.expand("$VIMRUNTIME")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua")] = true, -- Adiciona o diretório de runtime do Neovim para autocompletar funções e variáveis
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true, -- Adiciona o diretório de LSP do Neovim
							[vim.fn.stdpath("config") .. "/lua"] = true, -- Adiciona o diretório de configuração do usuário
							["${3rd}/luv/library"] = true, -- For luv:
							-- "${3rd}/busted/library", -- For testing with busted
							-- "${3rd}/luassert/library", -- For luassert
						},
					},
				}

				-- Adiciona dinamicamente os diretórios de plugins do lazy.nvim à biblioteca do LSP
				-- para que o autocompletar reconheça o código dos plugins.
				local plugin_paths = vim.fn.glob(vim.fn.stdpath("data") .. "/lazy/*", true, true)
				for _, path in ipairs(plugin_paths) do
					nvim_settings.workspace.library[path] = true
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, nvim_settings)

				-- Logar os caminhos dos plugins com nvim.notify
				-- for path, _ in pairs(client.config.settings.Lua.workspace.library) do
				--   vim.notify("LSP Lua workspace library: " .. path, vim.log.levels.INFO)
				-- end
			end,
		},
		ts_ls = {
			-- Configurações para TypeScript/JavaScript
			init_options = {
				preferences = {
					includeCompletionsWithSnippetText = true,
					includeCompletionsForImportStatements = true,
				},
			},
			single_file_support = false, -- Desativa o suporte a arquivos únicos para evitar conflitos com outros plugins
			root_dir = function(fname) --
				local util = lspconfig.util
				return not util.root_pattern("deno.json", "deno.jsonc")(fname) -- Define o diretório raiz do projeto
					and util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")(fname) -- Define o diretório raiz do projeto
			end,
		},
		emmet_ls = {
			-- Configurações para o emmet
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		},

		eslint = {
			-- Configurações para o linter ESLint
			-- Geralmente não precisa de muita coisa, mas aqui é o lugar para adicionar
		},
	}

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		"stylua", -- Usado para formatar codigo lua
	})
	-- Instala os servidores com mason
	mason_tool.setup({
		ensure_installed = servers,
	})

	-- Itera sobre a lista de servidores e aplica as configurações
	for server, config in pairs(servers) do
		config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})

		vim.lsp.config(server, config)
		vim.lsp.enable(server)

		-- local server_settings = settings[lsp] or {}
		-- server_settings.capabilities = capabilities -- Garante que todos os servidores usem as capabilities do nvim-cmp

		-- lspconfig[lsp].setup(server_settings)
	end
end

return LSP
