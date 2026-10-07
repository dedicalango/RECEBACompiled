# RECEBACompiled

Port inicial da arquitetura do projeto enviado pelo usuário para uma estrutura editável do RECEBA.

- `main.lua`: inicialização principal
- `loader.lua`: atualização/cache e reinjeção
- `guis/new.lua`: interface principal
- `games/universal.lua`: módulos universais
- `games/<PlaceId>.lua`: integrações específicas por jogo
- `libraries/`: bibliotecas compartilhadas
- `assets/new/`: assets usados pela GUI `new`

O dono/nome do repositório são lidos de `receba/profiles/repo_owner.txt` e `repo_name.txt`, criados pelo bootstrap.
