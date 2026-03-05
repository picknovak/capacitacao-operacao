Instalação mínima no macOS (Apple Silicon) para clonar e trabalhar com o repositório

1) Instalar Homebrew (se não tiver):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Após a instalação, siga as instruções que o instalador mostrar para adicionar `brew` ao `PATH`.

2) Instalar Git e OpenSSH:

```bash
brew install git
    brew install openssh
```

3) Gerar chave SSH (se não tiver):

```bash
ssh-keygen -t ed25519 -C "seu-email@example.com"
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub
# cole a chave no GitHub em Settings -> SSH and GPG keys
```

4) Clonar o repositório (substitua `<nome-repo>` se necessário):

```bash
git clone git@github.com:picknovak/<nome-repo>.git
cd <nome-repo>
```

5) Subir as mudanças locais para o GitHub (se você inicializar localmente):

```bash
git init
git status
git add . ## add tudo
git commit -m "Initial commit: auditoria scripts" ## registro CLARO sobre o que foi feito
git branch -M main
git remote add origin git@github.com:picknovak/<nome-repo>.git
git push -u origin main
```

Observações
- Em Apple Silicon (M1/M2), Homebrew instala em `/opt/homebrew`. Garanta que seu PATH inclua `/opt/homebrew/bin`.
- Se preferir HTTPS, use `https://github.com/picknovak/<nome-repo>.git` na hora de clonar.
