--- Configuração do Mason para o Neovim
--- @module 'alperan.config.mason'

local BaseConfig = require("alperan.config.base-config")
local Mason = BaseConfig.new()

--- Configura o Mason e o Mason LSPConfig.
---
---@return nil
function Mason.config()
    vim.env.PATH = vim.env.PATH .. ":/home/devuser/.python-global/bin"
    local mason = Mason:require_once("mason")
    local mason_lspconfig = Mason:require_once("mason-lspconfig")
    local mason_tool_installer = Mason:require_once("mason-tool-installer")

    -- Configuração do Mason
    mason.setup({
        ui = {
        border = "rounded", -- Define a borda da interface do usuário como arredondada
        icons = {
            package_installed = "✓", -- Ícone para pacotes instalados
            package_pending = "➜", -- Ícone para pacotes pendentes
            package_uninstalled = "✗", -- Ícone para pacotes não instalados
        },
        },
    })


    -- Configuração do Mason LSPConfig
    mason_lspconfig.setup({
        ensure_installed = { -- Lista de servidores LSP a serem instalados
        "lua_ls",
        "html",
        "cssls",
        "emmet_ls",
        "ts_ls",
        -- "eslint"
        "marksman", -- Adiciona o Marksman para Markdown
        "jsonls", -- Adiciona o JSON Language Server
        "bashls", -- Adiciona o Bash Language Server
        "pyright", -- Adiciona o Pyright para Python
        },
        automatic_enabled = true, -- Habilita a configuração automática dos servidores LSP
    })

    -- Configuração do Mason Tool Installer
    mason_tool_installer.setup({
        ensure_installed = {
        "prettier",
        "stylua",
        "isort",
        "pylint",
        "black", -- Adiciona o formatador Black para Python
        "clangd",
        "denols",
        -- { 'eslint_d', version = '13.1.2' },
        },
        auto_update = true, -- Atualiza automaticamente as ferramentas instaladas
        run_on_start = true, -- Executa o instalador ao iniciar o Neovim
    })

end

return Mason