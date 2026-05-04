export function generateBatContent(scriptUrl, language = 'es') {
  const isSpanish = language === 'es';

  const texts = {
    title: 'OFFICE HELPER PRO',
    subtitle: isSpanish ? 'Gestion Profesional de Office' : 'Professional Office Management',
    instructions: isSpanish ? 'INSTRUCCIONES' : 'INSTRUCTIONS',
    step1: isSpanish ? 'Se abrira PowerShell como Admin' : 'PowerShell will open as Admin',
    step2: isSpanish ? 'ACEPTA el aviso de seguridad (UAC)' : 'ACCEPT the security prompt (UAC)',
    step3: isSpanish ? 'En la ventana de PowerShell:' : 'In the PowerShell window:',
    step4: isSpanish ? 'Confirma con [S] y espera' : 'Confirm with [S] and wait',
    warning: isSpanish ? 'NO CIERRES LA VENTANA DE POWERSHELL' : 'DO NOT CLOSE THE POWERSHELL WINDOW',
    info: isSpanish ? 'Puedes seguir usando tu PC' : 'You can keep using your PC',
    pressKey: isSpanish ? 'Presiona cualquier tecla para comenzar...' : 'Press any key to start...',
    downloading: isSpanish ? 'DESCARGANDO SCRIPT...' : 'DOWNLOADING SCRIPT...',
    gettingLatest: isSpanish ? 'Obteniendo la version mas reciente...' : 'Getting the latest version...',
    adminPrompt: isSpanish ? 'ACEPTA el aviso de UAC que aparecera.' : 'ACCEPT the UAC prompt that will appear.',
    completed: isSpanish ? 'PROCESO FINALIZADO' : 'PROCESS COMPLETED',
    completedMsg: isSpanish ? 'La ventana de PowerShell se ha cerrado.' : 'The PowerShell window has closed.',
    completedMsg2: isSpanish ? 'Si todo salio bien, la accion se completo.' : 'If everything went well, the action is complete.',
    closeWindow: isSpanish ? 'Puedes cerrar esta ventana.' : 'You can close this window.',
    pressEnter: isSpanish ? 'Presiona Enter para salir' : 'Press Enter to exit',
  };

  return `@echo off
title ${texts.title}
color 0A
cls
echo.
echo ==========================================
echo         ${texts.title}
echo    ${texts.subtitle}
echo ==========================================
echo.
echo   ${texts.instructions}:
echo.
echo   1. ${texts.step1}
echo   2. ${texts.step2}
echo   3. ${texts.step3}
echo      [1] = ${isSpanish ? 'Instalar' : 'Install'}
echo      [2] = ${isSpanish ? 'Reparar' : 'Repair'}
echo      [3] = ${isSpanish ? 'Desinstalar' : 'Uninstall'}
echo   4. ${texts.step4}
echo.
echo   [!] ${texts.warning}
echo   [i] ${texts.info}
echo.
echo ==========================================
echo.
echo   ${texts.pressKey}
pause >nul

cls
echo.
echo ==========================================
echo      ${texts.downloading}
echo ==========================================
echo.
echo   ${texts.gettingLatest}
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$tempFile = [System.IO.Path]::GetTempPath() + 'office-tool.ps1'; Write-Host 'Downloading...' -ForegroundColor Yellow; try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '${scriptUrl}' -OutFile $tempFile; Write-Host 'Done.' -ForegroundColor Green; Write-Host 'Opening PowerShell as Administrator...' -ForegroundColor Yellow; Write-Host '${texts.adminPrompt}' -ForegroundColor Cyan; Start-Sleep -Seconds 2; Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File', $tempFile -Wait; Remove-Item $tempFile -ErrorAction SilentlyContinue; Write-Host 'Finished.' -ForegroundColor Green } catch { Write-Host 'ERROR' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Gray } finally { Read-Host '${texts.pressEnter}' }"

cls
echo.
echo ==========================================
echo      ${texts.completed}
echo ==========================================
echo.
echo   ${texts.completedMsg}
echo   ${texts.completedMsg2}
echo.
echo   ${texts.closeWindow}
echo.
pause
exit
`;
}