# Objetivo

Atue como um especialista em configuração de ambientes Linux modernos, com foco em **Hyprland**, **Lua** e arquitetura de configurações modulares.

Sua tarefa é migrar minhas configurações atuais do Hyprland para a nova abordagem baseada em Lua (`hyprland.lua`), mantendo inicialmente o comportamento atual o mais fiel possível, mas estruturando tudo de forma **idiomática**, **modular**, **escalável**, **simples de manter** e alinhada com a filosofia do ecossistema Hyprland/Lua.

A migração NÃO deve apenas converter sintaxe.  
Ela deve reorganizar e estruturar a configuração de maneira sustentável para evolução futura.

---

# Contexto Importante

O Hyprland está migrando oficialmente para configuração baseada em Lua a partir da série 0.55.  
A própria equipe do projeto enfatiza:

- configs mais legíveis
- modularização
- reutilização
- eventos/callbacks
- extensibilidade
- scripting idiomático em Lua

Referências:

- https://hypr.land/news/26_lua/
- https://wiki.hypr.land/Configuring/Start/
- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Expanding-functionality/
- https://wiki.hypr.land/Configuring/Layouts/Custom-Layouts/

Também use como inspiração estrutural:

- https://github.com/colonelpanic8/dotfiles/blob/master/dotfiles/config/hypr/hyprland.lua
- https://www.reddit.com/r/hyprland/comments/1t74dt6/pre055_discussion_share_your_new_lua_scripts_that/

E considere boas práticas discutidas pela comunidade sobre configs modulares:
- separação por domínio
- regras por aplicação
- profiles de monitor
- organização de keybinds
- isolamento de features opcionais
- reuso de utilitários Lua

---

# Requisitos Arquiteturais

A estrutura deve priorizar:

- simplicidade
- clareza
- manutenção
- baixo acoplamento
- organização por domínio funcional
- facilidade de extensão futura
- idiomatismo Lua
- idiomatismo Hyprland
- legibilidade acima de abstrações excessivas

---

# MUITO IMPORTANTE

NÃO tente transformar a configuração em uma aplicação enterprise.

Evite padrões exagerados ou desnecessários vindos de:
- Java
- Spring
- Go
- Rust
- Clean Architecture
- DDD
- Service/Repository patterns
- Dependency Injection complexa
- factories desnecessárias
- abstrações artificiais

Isso é uma configuração de desktop/window manager.

Prefira:
- tabelas Lua simples
- funções pequenas
- módulos pequenos
- composição simples
- helpers reutilizáveis
- separação pragmática

---

# Objetivo Inicial

O foco inicial NÃO é reinventar a configuração.

O foco inicial é:

1. preservar comportamento atual
2. migrar com segurança
3. reduzir complexidade acidental
4. estruturar modularmente
5. preparar para evolução futura

Evite refactors destrutivos no começo.

---

# Estrutura Esperada

A organização deve seguir algo próximo disso (adapte conforme necessário):

```txt
~/.config/hypr/
├── hyprland.lua
├── core/
│   ├── options.lua
│   ├── env.lua
│   ├── monitors.lua
│   ├── variables.lua
│   └── autostart.lua
├── input/
│   ├── keyboard.lua
│   ├── mouse.lua
│   ├── touchpad.lua
│   └── keybinds.lua
├── ui/
│   ├── appearance.lua
│   ├── animations.lua
│   ├── decoration.lua
│   ├── blur.lua
│   └── themes.lua
├── rules/
│   ├── windows.lua
│   ├── workspaces.lua
│   ├── floating.lua
│   └── apps/
│       ├── firefox.lua
│       ├── discord.lua
│       └── steam.lua
├── layouts/
│   ├── default.lua
│   └── custom/
├── scripts/
│   └── helpers.lua
├── events/
│   ├── startup.lua
│   ├── workspace.lua
│   └── notifications.lua
└── lib/
    ├── utils.lua
    ├── bind.lua
    └── table.lua
````

---

# Regras de Modularização

## Separar por domínio funcional

Exemplos:

* monitores
* input
* aparência
* binds
* regras de janela
* automações
* layouts
* integrações

---

## Regras específicas por aplicação

Sempre que fizer sentido, separar regras por aplicação:

Exemplo:

```txt
rules/apps/
├── firefox.lua
├── spotify.lua
├── obsidian.lua
└── steam.lua
```

---

## Keybinds

Keybinds devem ser organizados:

* por categoria
* por contexto
* por feature

Exemplo:

```txt
input/keybinds/
├── apps.lua
├── media.lua
├── screenshots.lua
├── workspaces.lua
└── windows.lua
```

---

# Estilo de Código Esperado

Prefira módulos declarativos simples quando o objetivo for apenas expor configuração estática, opções, listas, regras ou dados.

Exemplo ideal para configs declarativas:

```lua
return {
  gaps_in = 5,
  gaps_out = 10,
}
```

Isso tende a ser mais:
- idiomático em Lua
- legível
- simples
- declarativo
- fácil de compor
- fácil de manter

---

Evite boilerplate desnecessário como:

```lua
local M = {}

function M.get()
  return {
    gaps_in = 5,
    gaps_out = 10,
  }
end

return M
```

quando o módulo apenas retorna dados estáticos.

Nesse tipo de caso, isso adiciona:
- indireção desnecessária
- ruído visual
- abstração sem ganho real
- complexidade acidental

---

# Quando usar `local M = {}`

O padrão:

```lua
local M = {}

function M.foo()
end

return M
```

PODE e DEVE ser utilizado quando realmente fizer sentido arquiteturalmente.

Exemplos válidos:

- módulos utilitários
- helpers reutilizáveis
- composição dinâmica
- lazy loading
- encapsulamento de comportamento
- funções reutilizáveis
- integração com APIs/eventos
- módulos com estado
- lógica procedural
- automações
- wrappers do Hyprland

Exemplo:

```lua
local M = {}

function M.notify(msg)
  os.execute(("notify-send '%s'"):format(msg))
end

function M.reload()
  os.execute("hyprctl reload")
end

return M
```

---

Outro exemplo válido:

```lua
local M = {}

function M.detect()
  if os.getenv("LAPTOP") then
    return require("monitors.laptop")
  end

  return require("monitors.desktop")
end

return M
```

---

# Objetivo

O objetivo NÃO é proibir `local M = {}`.

O objetivo é:
- evitar abstrações artificiais
- evitar boilerplate desnecessário
- evitar transformar configuração em framework
- evitar padrões excessivos vindos de Java/Go/Rust
- manter a configuração idiomática para Lua e Hyprland

---

# Regra Geral

Use:
- `return {}` para módulos declarativos
- `local M = {}` para módulos comportamentais

Sempre priorizando:
- pragmatismo
- clareza
- simplicidade
- manutenção
- idiomatismo Lua



---

# Helpers

Crie helpers apenas quando:

* eliminarem repetição real
* melhorarem legibilidade
* simplificarem manutenção

Evite abstrações prematuras.

---

# Eventos e Callbacks

Use eventos Lua do Hyprland apenas quando realmente agregarem valor.

Exemplos válidos:

* notificações
* automações de workspace
* startup hooks
* monitor attach/detach
* scripts dinâmicos

Evite transformar tudo em eventos sem necessidade.

---

# Compatibilidade

A configuração deve:

* continuar fácil de debugar
* funcionar sem dependências desnecessárias
* degradar graciosamente
* evitar "magic behavior"
* evitar metaprogramação excessiva

---

# Performance

Evite:

* loops desnecessários
* requires redundantes
* carregamento dinâmico exagerado
* lógica pesada no startup

A config deve continuar leve e rápida.

---

# O que analisar durante a migração

Durante a análise da configuração atual:

1. Identifique duplicações
2. Identifique responsabilidades misturadas
3. Identifique módulos naturais
4. Identifique regras específicas de apps
5. Identifique binds agrupáveis
6. Identifique valores reutilizáveis
7. Identifique automações que podem virar helpers/eventos
8. Identifique hacks que podem ser simplificados em Lua

---

# Resultado Esperado

Quero receber:

1. Nova estrutura de diretórios
2. Explicação arquitetural
3. Estratégia de modularização
4. Migração incremental segura
5. Código final organizado
6. Sugestões futuras opcionais
7. Justificativas técnicas das decisões

---

# Importante

Sempre priorize:

* pragmatismo
* clareza
* idiomatismo
* manutenção
* simplicidade

Ao invés de:

* engenharia excessiva
* abstrações desnecessárias
* complexidade artificial

A configuração deve parecer:

* natural para usuários de Hyprland
* natural para usuários Lua
* fácil de entender meses depois
* fácil de evoluir gradualmente
