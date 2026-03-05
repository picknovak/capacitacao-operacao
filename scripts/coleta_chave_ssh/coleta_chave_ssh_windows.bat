@echo off
setlocal enabledelayedexpansion

REM Gera chave SSH publica e salva um TXT na pasta atual para envio.
REM Requer OpenSSH Client (ssh-keygen) instalado no Windows.

where ssh-keygen >nul 2>&1
if errorlevel 1 (
  echo [ERRO] ssh-keygen nao foi encontrado.
  echo Instale o "OpenSSH Client" nas funcionalidades opcionais do Windows.
  pause
  exit /b 1
)

set "SSH_DIR=%USERPROFILE%\.ssh"
if not exist "%SSH_DIR%" mkdir "%SSH_DIR%"

set "DEFAULT_COMMENT=%USERNAME%@%COMPUTERNAME%"
set /p KEY_COMMENT=Informe um comentario para a chave [%DEFAULT_COMMENT%]:
if "%KEY_COMMENT%"=="" set "KEY_COMMENT=%DEFAULT_COMMENT%"

set "KEY_FILE=%SSH_DIR%\id_ed25519_tunnel_externo"
if exist "%KEY_FILE%" (
  set "STAMP=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"
  set "STAMP=%STAMP: =0%"
  set "KEY_FILE=%SSH_DIR%\id_ed25519_tunnel_externo_!STAMP!"
)

echo.
echo Gerando chave em: %KEY_FILE%
ssh-keygen -t ed25519 -a 100 -C "%KEY_COMMENT%" -f "%KEY_FILE%" -N ""
if errorlevel 1 (
  echo [ERRO] Falha ao gerar chave SSH.
  pause
  exit /b 1
)

set "OUT_FILE=%CD%\chave_publica_ssh.txt"
type "%KEY_FILE%.pub" > "%OUT_FILE%"

echo.
echo Chave publica salva em:
echo %OUT_FILE%
echo.
echo Envie APENAS esse arquivo TXT.

start notepad "%OUT_FILE%"
pause
