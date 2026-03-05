# Rotina Diária - Saúde do OpenProject

Objetivo: verificar diariamente a saúde do OpenProject no servidor e auditar quem se conectou via SSH.

## 1. Execução manual (via SSH)

No servidor:

```bash
cd /opt/operacao/capacitacao-operacao
chmod +x scripts/openproject_daily_health.sh
sudo ./servidor/scripts/openproject_daily_health.sh
```

Opcional (checar TLS do domínio):

```bash
sudo OPENPROJECT_HOST=seu-dominio.exemplo ./servidor/scripts/openproject_daily_health.sh
```

Saída:
- Relatório em `relatorios/openproject_daily/openproject_daily_YYYYMMDD_HHMMSS.txt`
- Código de retorno:
- `0` = OK
- `1` = atenção (warnings)
- `2` = crítico

## 2. Agendamento diário (cron)

Editar crontab do `root`:

```bash
sudo crontab -e
```

Exemplo (todos os dias às 07:10):

```cron
10 7 * * * cd /opt/operacao/capacitacao-operacao && /usr/bin/env bash ./servidor/scripts/openproject_daily_health.sh >> ./servidor/relatorios/openproject_daily/cron.log 2>&1
```

Se quiser checar TLS do domínio:

```cron
10 7 * * * cd /opt/operacao/capacitacao-operacao && OPENPROJECT_HOST=seu-dominio.exemplo /usr/bin/env bash ./servidor/scripts/openproject_daily_health.sh >> ./servidor/relatorios/openproject_daily/cron.log 2>&1
```

## 3. O que o script verifica

- Saúde do host: uptime, memória, disco, inodes
- Docker: status do serviço, uso de disco Docker
- OpenProject: containers detectados, status, healthcheck, restarts, logs recentes
- Exposição de rede: portas abertas e firewall (`ufw`/`nftables`)
- SSH (24h): logins com sucesso, falhas, IPs mais ativos, últimos logins
- Fragilidade: uso de root via SSH, volume alto de falhas, disco/memória em risco
- TLS (opcional): dias restantes do certificado HTTPS

## 4. Leitura rápida do relatório

No fim do arquivo, veja:

- `WARN=...`
- `CRIT=...`
- `STATUS=OK|ATENCAO|CRITICO`

Se aparecer `STATUS=CRITICO`, agir no mesmo dia:
- container OpenProject parado/unhealthy
- disco quase cheio
- falha forte de infraestrutura

## 5. Próximo passo recomendado (opcional)

Automatizar alerta por e-mail/Telegram quando o script retornar `1` ou `2`.
