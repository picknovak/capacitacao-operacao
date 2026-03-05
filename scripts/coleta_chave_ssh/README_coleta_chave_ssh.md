# Coleta de chave publica SSH (tunnel_externo)

Voce precisa apenas gerar um arquivo `.txt` e enviar esse arquivo.

## Antes de comecar 

Salve o script do seu sistema na pasta `Downloads`.

O manual contempla Windows, MacOs e Linux

## Windows (arquivo .bat)

Arquivo: `coleta_chave_ssh_windows.bat`

1. Va para a pasta `Downloads`.
2. Clique duas vezes em `coleta_chave_ssh_windows.bat`.
3. Se aparecer uma pergunta de seguranca, confirme a execucao.
4. Uma janela preta sera aberta.
5. Quando pedir comentario da chave, pressione `Enter` para aceitar o padrao.
6. Aguarde ate aparecer a mensagem de sucesso.
7. O bloco de notas abrira com o arquivo pronto.
8. Envie o arquivo `chave_publica_ssh.txt` que ficou na mesma pasta onde o script foi executado.
9. Se voce executou pela pasta `Downloads`, o arquivo estara em `Downloads`.

Se aparecer erro sobre `ssh-keygen`, chame alguem da infraestrutura

## macOS

Arquivo: `coleta_chave_ssh_macos.sh`

1. Abra o app `Terminal`.
2. Copie e cole os comandos abaixo, um por vez (nao precisa escrever):

```bash
cd ~/Downloads
chmod +x coleta_chave_ssh_macos.sh
./coleta_chave_ssh_macos.sh
```
Os comandos fazem:
- cd ~/Downloads -> abre a pasta downloads
- chmod +x coleta_chave_ssh_mac.sh -> permitem que o arquivo seja executado
- ./coleta_chave_ssh_mac.sh -> executam o arquivo

3. Quando pedir comentario da chave, pressione `Enter`.
4. Aguarde a mensagem de sucesso.
5. Envie o arquivo `chave_publica_ssh.txt` da mesma pasta onde voce executou os comandos.
6. Como o passo usa `cd ~/Downloads`, o arquivo ficara em `Downloads`.

## Linux

Arquivo: `coleta_chave_ssh_linux.sh`

1. Abra o `Terminal`.
2. Copie e cole os comandos abaixo, um por vez (nao precisa escrever):

```bash
cd ~/Downloads
chmod +x coleta_chave_ssh_linux.sh
./coleta_chave_ssh_linux.sh
```
Os comandos fazem:
- cd ~/Downloads -> abre a pasta downloads
- chmod +x coleta_chave_ssh_linux.sh -> permitem que o arquivo seja executado
- ./coleta_chave_ssh_linux.sh -> executam o arquivo

3. Quando pedir comentario da chave, pressione `Enter`.
4. Aguarde a mensagem de sucesso.
5. Envie o arquivo `chave_publica_ssh.txt` da mesma pasta onde voce executou os comandos.
6. Como o passo usa `cd ~/Downloads`, o arquivo ficara em `Downloads`.

## Como saber se esta certo

1. Abra o arquivo `chave_publica_ssh.txt`.
2. O conteudo deve ser uma unica linha com inicio parecido com:
   `ssh-ed25519 AAAA...`

## Importante

1. Envie somente `chave_publica_ssh.txt`.
2. Nunca envie chave privada (arquivo sem `.pub` dentro de `~/.ssh`).
