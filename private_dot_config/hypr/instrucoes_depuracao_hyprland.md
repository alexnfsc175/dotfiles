# Guia Rápido para Depuração de Configurações do Hyprland

Este guia resume os passos e comandos essenciais para diagnosticar e resolver erros após modificar sua configuração do Hyprland.

---

### Passo 1: Verificação Direta de Erros

O primeiro e mais direto comando para verificar a sintaxe dos seus arquivos de configuração.

```bash
hyprctl configerrors
```
Este comando lerá todos os seus arquivos `.conf` carregados e apontará erros de sintaxe, palavras-chave obsoletas ou parâmetros inválidos.

---

### Passo 2: Verificação de Logs em Tempo Real

Nem todos os problemas são erros de sintaxe. Alguns são avisos ou falhas que ocorrem durante a execução. O `journalctl` é seu amigo para isso.

**Para ver todas as mensagens do Hyprland desde a última inicialização:**
```bash
journalctl -b | grep -i hyprland
```

**Para filtrar apenas por ERROS e AVISOS (altamente recomendado):**
```bash
journalctl -b | grep -iE "hyprland.*(error|warning)"
```

**Para verificar se uma correção funcionou (mostra apenas logs dos últimos 2 minutos):**
```bash
journalctl --since "2 minutes ago" | grep -iE "hyprland.*(error|warning)"
```
Se este comando não retornar nada após você aplicar uma correção, é um ótimo sinal.

---

### Passo 3: Aplicando as Mudanças

Após editar um arquivo `.conf`, você **precisa** recarregar o Hyprland para que as mudanças tenham efeito.

```bash
hyprctl reload
```
**Importante:** Execute este comando *antes* de verificar os erros novamente com os comandos do Passo 1 e 2.

---

### Passo 4: A Fonte da Verdade - A Wiki

Se encontrar um erro sobre uma palavra-chave ou sintaxe que não reconhece, a Wiki do Hyprland é o melhor lugar para procurar.

- **Endereço:** [https://wiki.hyprland.org/](https://wiki.hyprland.org/)
- **Como pesquisar:** Use o nome da palavra-chave que deu erro na busca. Por exemplo, se o erro for sobre `decoration`, pesquise por "decoration" na wiki.

---

### Boas Práticas (Para Evitar Dores de Cabeça)

1.  **Faça Backups Simples:** Antes de uma grande alteração em um arquivo como `rules.conf`, faça uma cópia rápida.
    ```bash
    cp theme/rules.conf theme/rules.conf.bkp_antes_da_mudanca
    ```
2.  **Mude Uma Coisa de Cada Vez:** Em vez de alterar 20 linhas, altere uma ou duas, salve, execute `hyprctl reload` e verifique os erros. Isso ajuda a isolar a causa do problema imediatamente.
3.  **Quando Tudo Falhar, Peça Ajuda:** Se você está em um ciclo de erros que não fazem sentido (como o que aconteceu conosco), pode ser um bug na sua versão do Hyprland.
    *   **Comunidades:** O Discord oficial do Hyprland e o subreddit `r/hyprland` são excelentes lugares.
    *   **O que fornecer:** Ao pedir ajuda, sempre inclua a saída de `hyprctl configerrors` e `journalctl -b | grep -iE "hyprland.*(error|warning)"`, além dos seus arquivos de configuração relevantes.
