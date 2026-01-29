# Guia de Gerenciamento de Dotfiles com Chezmoi

Este guia explica como gerenciar seus arquivos de configuração (dotfiles) usando o **Chezmoi**, com base no fluxo de trabalho que configuramos.

## 1. Conceito Básico
O Chezmoi mantém uma cópia dos seus arquivos de configuração em um diretório separado (`~/.local/share/chezmoi`) que é um repositório Git.
- **Source State**: Os arquivos armazenados no repositório do Chezmoi.
- **Target State**: Os arquivos reais na sua pasta pessoal (`~`).

O objetivo é manter esses dois estados sincronizados e enviar o *Source State* para o GitHub.

## 2. Comandos do Dia a Dia

### Verificar Status
Para ver o que mudou na sua máquina em relação ao repositório:
```bash
chezmoi status
```
- A saída vazia significa que tudo está sincronizado.
- `MM`: O arquivo foi modificado localmente.
- `M`: Apenas os metadados mudaram.
- `??`: Arquivo não gerenciado (se você rodar commands que mostram todos).

### Adicionar um Novo Arquivo/Pasta
Para começar a rastrear um arquivo que ainda não está no Chezmoi:
```bash
chezmoi add ~/.config/caminho/do/arquivo_ou_pasta
```
*Exemplo:* `chezmoi add ~/.config/hypr/novo_script.sh`

### Editar Arquivos
Você pode editar os arquivos normalmente na sua pasta pessoal. O Chezmoi vai detectar a mudança (veja `chezmoi status`).
Para aplicar essa mudança ao repositório do Chezmoi (Source State):
```bash
chezmoi re-add ~/.config/caminho/do/arquivo_editado
```
*Dica:* Use `chezmoi re-add .` para adicionar todas as alterações locais de uma vez.

### Sincronizar com o GitHub
Depois de atualizar o repositório local do Chezmoi (com `add` ou `re-add`), você precisa enviar para o GitHub. O Chezmoi atua como um wrapper para o git:

1.  **Adicionar ao Stage**:
    ```bash
    chezmoi git add .
    ```
2.  **Commitar**:
    ```bash
    chezmoi git commit -m "Mensagem descrevendo a mudança"
    ```
3.  **Enviar (Push)**:
    ```bash
    chezmoi git push
    ```

## 3. Fluxo Inverso (Do GitHub para a Máquina)
Se você fizer alterações em outra máquina ou editar direto no GitHub, use:

1.  **Baixar as alterações**:
    ```bash
    chezmoi update
    ```
    Isso faz o `git pull` e aplica as mudanças nos seus arquivos locais.

## 4. Dicas Úteis

- **Esquecer um arquivo**: Se quiser parar de rastrear um arquivo sem apagá-lo do disco:
  ```bash
  chezmoi forget ~/.config/arquivo
  ```

- **Verificar Diferenças**: Antes de aplicar ou adicionar, veja o que mudou:
  ```bash
  chezmoi diff
  ```

- **Cd para o diretório do repo**: Se quiser rodar comandos git manuais ou explorar os arquivos:
  ```bash
  chezmoi cd
  ```
  (Digite `exit` para sair).

---
**Resumo do Fluxo de Trabalho Típico:**
1. Edite seu arquivo de config (ex: `nvim ~/.config/hypr/hyprland.conf`).
2. Verifique: `chezmoi status` (deve aparecer `MM`).
3. Atualize o source: `chezmoi re-add ~/.config/hypr/hyprland.conf`.
4. Envie: `chezmoi git -- add . && chezmoi git -- commit -m "update hyprland" && chezmoi git -- push`.
