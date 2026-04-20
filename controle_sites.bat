@echo off
title CONTROLE DE SITES - FOCO
color 0A

set HOSTS=C:\Windows\System32\drivers\etc\hosts
set TAG=#BLOCK_FOCO

:menu
cls
echo ==========================================
echo        CONTROLE DE SITES (FOCO)
echo ==========================================
echo 1 - Bloquear sites distrativos
echo 2 - Desbloquear sites
echo 3 - Verificar bloqueios ativos
echo 0 - Sair
echo ==========================================
set /p opcao=Escolha uma opcao:

if "%opcao%"=="1" goto bloquear
if "%opcao%"=="2" goto desbloquear
if "%opcao%"=="3" goto status
if "%opcao%"=="0" exit

goto menu

:bloquear
cls
echo Criando backup do hosts...
copy %HOSTS% %HOSTS%.bak >nul

echo Aplicando bloqueios...

call :addsite exemplo1.com
call :addsite exemplo2.com

ipconfig /flushdns >nul

echo.
echo Bloqueio concluido!
pause
goto menu

:desbloquear
cls
echo Removendo bloqueios...

findstr /v "%TAG%" %HOSTS% > %HOSTS%.tmp
copy /y %HOSTS%.tmp %HOSTS% >nul
del %HOSTS%.tmp >nul

ipconfig /flushdns >nul

echo.
echo Desbloqueio concluido!
pause
goto menu

:status
cls
echo Bloqueios atuais:
findstr "%TAG%" %HOSTS%
echo.
pause
goto menu

:addsite
set SITE=%1

findstr /c:"%SITE% %TAG%" %HOSTS% >nul
if %errorlevel%==0 (
    echo %SITE% ja esta bloqueado
) else (
    echo 127.0.0.1 %SITE% %TAG%>> %HOSTS%
    echo 127.0.0.1 www.%SITE% %TAG%>> %HOSTS%
    echo Bloqueado: %SITE%
)
goto :eof