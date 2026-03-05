#!/usr/bin/env bash
set -euo pipefail

# Gera chave SSH publica e salva um TXT na pasta atual para envio.

if ! command -v ssh-keygen >/dev/null 2>&1; then
  echo "[ERRO] ssh-keygen nao encontrado."
  exit 1
fi

SSH_DIR="$HOME/.ssh"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

DEFAULT_COMMENT="${USER}@$(scutil --get ComputerName 2>/dev/null || hostname)"
read -r -p "Informe um comentario para a chave [${DEFAULT_COMMENT}]: " KEY_COMMENT
KEY_COMMENT="${KEY_COMMENT:-$DEFAULT_COMMENT}"

KEY_FILE="$SSH_DIR/id_ed25519_tunnel_externo"
if [[ -e "$KEY_FILE" ]]; then
  STAMP="$(date +%Y%m%d_%H%M%S)"
  KEY_FILE="$SSH_DIR/id_ed25519_tunnel_externo_${STAMP}"
fi

echo
echo "Gerando chave em: $KEY_FILE"
ssh-keygen -t ed25519 -a 100 -C "$KEY_COMMENT" -f "$KEY_FILE" -N ""

OUT_FILE="$PWD/chave_publica_ssh.txt"
cp "${KEY_FILE}.pub" "$OUT_FILE"
chmod 600 "$OUT_FILE"

echo
echo "Chave publica salva em:"
echo "$OUT_FILE"
echo
echo "Envie APENAS esse arquivo TXT."

if command -v pbcopy >/dev/null 2>&1; then
  cat "$OUT_FILE" | pbcopy
  echo "A chave publica tambem foi copiada para a area de transferencia."
fi
