<#
.SYNOPSIS
    Office Helper v12 - By Naymon Dominguez
.DESCRIPTION
    Herramienta completa para gestionar Microsoft Office.
    - Instalacion 100% automatica con descarga directa
    - Activacion via MAS con instrucciones claras
    - Reparacion via MAS
    - Desinstalacion nativa de Windows (sin MAS)
    - Verificacion de estado nativa (PowerShell + WMI)
    - Solucion de problemas via MAS
    - Informacion del sistema
.NOTES
    Version: 12.0
    Autor: Naymon Dominguez
#>

param([string]$Lang = "es-es")

$host.UI.RawUI.WindowTitle = "Office Helper - By Naymon Dominguez"
$ProgressPreference = 'SilentlyContinue'
$LogFile = "$env:TEMP\office-helper-log.txt"

# ============================================
# COLORES
# ============================================
$C = @{
    Cyan    = 'Cyan'
    Green   = 'Green'
    Yellow  = 'Yellow'
    Red     = 'Red'
    White   = 'White'
    Gray    = 'DarkGray'
    Magenta = 'Magenta'
    DarkGray= 'DarkGray'
}

# ============================================
# BASE DE DATOS DE VERSIONES
# ============================================
$Versions = @(
    @{N=1;  Name="Microsoft 365 ProPlus";        ID="O365ProPlusRetail";      Cat="Microsoft 365"; Desc="Word, Excel, PowerPoint, Outlook, Access, Publisher, OneNote"; Feat=$true},
    @{N=2;  Name="Microsoft 365 Business";       ID="O365BusinessRetail";     Cat="Microsoft 365"; Desc="Word, Excel, PowerPoint, Outlook, Access, Publisher"; Feat=$false},
    @{N=3;  Name="Microsoft 365 Home Premium";   ID="O365HomePremRetail";     Cat="Microsoft 365"; Desc="Word, Excel, PowerPoint, Outlook, Access, Publisher"; Feat=$false},
    @{N=4;  Name="Office 2024 ProPlus";          ID="ProPlus2024Retail";      Cat="Office 2024";   Desc="Todas las aplicaciones"; Feat=$true},
    @{N=5;  Name="Office 2024 Home";             ID="Home2024Retail";         Cat="Office 2024";   Desc="Word, Excel, PowerPoint"; Feat=$false},
    @{N=6;  Name="Office 2024 Home & Business";  ID="HomeBusiness2024Retail"; Cat="Office 2024";   Desc="Word, Excel, PowerPoint, Outlook"; Feat=$false},
    @{N=7;  Name="Office 2021 ProPlus";          ID="ProPlus2021Retail";      Cat="Office 2021";   Desc="Todas las aplicaciones"; Feat=$true},
    @{N=8;  Name="Office 2021 Home & Student";   ID="HomeStudent2021Retail";  Cat="Office 2021";   Desc="Word, Excel, PowerPoint"; Feat=$false},
    @{N=9;  Name="Office 2021 Home & Business";  ID="HomeBusiness2021Retail"; Cat="Office 2021";   Desc="Word, Excel, PowerPoint, Outlook"; Feat=$false},
    @{N=10; Name="Office 2021 Professional";     ID="Professional2021Retail"; Cat="Office 2021";   Desc="Suite completa"; Feat=$false},
    @{N=11; Name="Office 2019 ProPlus";          ID="ProPlus2019Retail";      Cat="Office 2019";   Desc="Todas las aplicaciones"; Feat=$true},
    @{N=12; Name="Office 2019 Home & Student";   ID="HomeStudent2019Retail";  Cat="Office 2019";   Desc="Word, Excel, PowerPoint"; Feat=$false},
    @{N=13; Name="Office 2019 Home & Business";  ID="HomeBusiness2019Retail"; Cat="Office 2019";   Desc="Word, Excel, PowerPoint, Outlook"; Feat=$false},
    @{N=14; Name="Office 2016 ProPlus";          ID="ProPlusRetail";          Cat="Office 2016";   Desc="Todas las aplicaciones"; Feat=$true},
    @{N=15; Name="Office 2016 Home & Student";   ID="HomeStudentRetail";      Cat="Office 2016";   Desc="Word, Excel, PowerPoint"; Feat=$false},
    @{N=16; Name="Office 2016 Home & Business";  ID="HomeBusinessRetail";     Cat="Office 2016";   Desc="Word, Excel, PowerPoint, Outlook"; Feat=$false}
)

# ============================================
# TRADUCCIONES COMPLETAS (ES)
# ============================================
$MSG = @{
    BannerTitle     = "OFFICE HELPER"
    BannerSub       = "Gestion de Microsoft Office"
    BannerBy        = "Desarrollado por Naymon Dominguez"
    BannerVersion   = "v12.0"
    AdminReq        = "PERMISOS DE ADMINISTRADOR REQUERIDOS"
    AdminInfo       = "Se abrira una nueva ventana con permisos elevados."
    AdminAccept     = "Por favor, ACEPTA el aviso de seguridad (UAC)."
    PressCont       = "Presiona cualquier tecla para continuar..."
    PressBack       = "Presiona cualquier tecla para volver al menu principal..."
    Choose          = "Elige una opcion"
    Invalid         = "Opcion no valida. Intenta de nuevo."
    Back            = "Volver"
    InternetOK      = "Conexion a internet detectada"
    InternetFail    = "Sin conexion a internet"
    NoInternet      = "No hay conexion a internet. Conectate e intenta de nuevo."

    InstallingTitle = "INSTALANDO MICROSOFT OFFICE"
    CheckingDisk    = "Verificando espacio en disco..."
    DiskOK          = "Espacio disponible en disco"
    DiskLow         = "ESPACIO INSUFICIENTE"
    Need10GB        = "Se necesitan al menos 10 GB libres"
    Downloading     = "Descargando instalador oficial de Microsoft..."
    Downloaded      = "Instalador descargado correctamente"
    RunningSetup    = "Ejecutando instalador de Office..."
    SetupInfo       = "Se abrira la ventana de instalacion de Microsoft Office"
    SetupInfo2      = "La instalacion es completamente automatica."
    SetupInfo3      = "NO CIERRES la ventana del instalador."
    InstallDone     = "INSTALACION COMPLETADA CON EXITO"
    InstallDoneMsg  = "Microsoft Office ha sido instalado correctamente."
    ActivateAfter   = "AHORA USA LA OPCION [2] PARA ACTIVARLO"
    InstallError    = "ERROR DURANTE LA INSTALACION"

    ActivatingTitle = "ACTIVAR MICROSOFT OFFICE"
    CheckingOffice  = "Verificando instalacion de Office..."
    NoOffice        = "OFFICE NO ESTA INSTALADO"
    OfficeFound     = "Office detectado correctamente en el sistema."
    ActInstrTitle   = "INSTRUCCIONES PARA ACTIVAR OFFICE"
    ActInstr1       = "Se abrira Microsoft Activation Scripts (MAS)."
    ActInstr2       = "En el menu principal, presiona la tecla [2]"
    ActInstr3       = "Luego ENTER para entrar a Ohook."
    ActInstr4       = "En el menu de Ohook, presiona la tecla [1]"
    ActInstr5       = "Luego ENTER para instalar la activacion."
    ActInstr6       = "Espera a que termine. Office quedara activado."
    ActRunning      = "Abriendo Microsoft Activation Scripts..."
    ActSuccess      = "ACTIVACION COMPLETADA CON EXITO"
    ActSuccessMsg   = "Microsoft Office ha sido activado permanentemente."

    WinActTitle     = "ACTIVAR WINDOWS"
    WinInstrTitle   = "INSTRUCCIONES PARA ACTIVAR WINDOWS"
    WinInstr1       = "Se abrira Microsoft Activation Scripts (MAS)."
    WinInstr2       = "En el menu principal, presiona la tecla [1]"
    WinInstr3       = "Luego ENTER para entrar a HWID."
    WinInstr4       = "Requiere conexion a internet."
    WinRunning      = "Abriendo Microsoft Activation Scripts..."
    WinSuccess      = "ACTIVACION COMPLETADA CON EXITO"
    WinSuccessMsg   = "Windows ha sido activado con licencia digital."

    RepairTitle     = "REPARAR MICROSOFT OFFICE"
    RepairInstr1    = "Se abrira Microsoft Activation Scripts (MAS)."
    RepairInstr2    = "En el menu principal, presiona la tecla [8]"
    RepairInstr3    = "Luego ENTER para Troubleshoot."
    RepairInstr4    = "En Troubleshoot, selecciona [5] Fix Licensing."
    RepairRunning   = "Abriendo Microsoft Activation Scripts..."

    UninstallTitle  = "DESINSTALAR MICROSOFT OFFICE"
    UninstallScan   = "Buscando instalaciones de Microsoft Office..."
    UninstallFound  = "Se encontraron las siguientes instalaciones:"
    UninstallNone   = "No se encontro Microsoft Office instalado en este equipo."
    UninstallWhich  = "Que deseas hacer?"
    UninstallAll    = "[1] Desinstalar TODAS las versiones de Office encontradas"
    UninstallOne    = "[2] Seleccionar cual desinstalar"
    UninstallCancel = "[0] Cancelar y volver al menu"
    UninstallSelect = "Selecciona el numero de la version a desinstalar:"
    Uninstalling    = "Desinstalando"
    UninstallDone   = "Desinstalacion completada."
    UninstallFail   = "No se pudo desinstalar. Intenta desde Configuracion > Aplicaciones."

    CheckTitle      = "VERIFICAR ESTADO DE ACTIVACION"
    CheckWin        = "WINDOWS"
    CheckOffice     = "OFFICE"
    CheckActivated  = "ACTIVADO"
    CheckNotAct     = "NO ACTIVADO"
    CheckUnknown    = "NO SE PUDO DETERMINAR"
    CheckGrace      = "EN PERIODO DE GRACIA (NO ACTIVADO)"
    CheckDays       = "dias restantes"
    CheckPermanent  = "LICENCIA PERMANENTE (DIGITAL)"
    CheckKMS        = "ACTIVADO POR KMS"

    ToolsTitle      = "SOLUCION DE PROBLEMAS"
    ToolsInstr1     = "Se abrira Microsoft Activation Scripts (MAS)."
    ToolsInstr2     = "En el menu principal, presiona la tecla [8]"
    ToolsInstr3     = "Luego ENTER para acceder a Troubleshoot."

    SysInfoTitle    = "INFORMACION DEL SISTEMA"
    SysInfoWin      = "WINDOWS"
    SysInfoHW       = "HARDWARE"
    SysInfoOffice   = "OFFICE"
    SysInfoNet      = "RED"
    SysInfoSO       = "Sistema Operativo"
    SysInfoBuild    = "Build"
    SysInfoArch     = "Arquitectura"
    SysInfoCPU      = "Procesador"
    SysInfoRAM      = "Memoria RAM"
    SysInfoDisk     = "Disco C"
    SysInfoFree     = "GB libres"
    SysInfoOFFInst  = "INSTALADO"
    SysInfoOFFNo    = "NO INSTALADO"
    SysInfoNetOK    = "CONECTADO"
    SysInfoNetFail  = "DESCONECTADO"

    MenuMainTitle   = "OFFICE HELPER"
    MenuMainSub     = "Menu Principal"
    MenuOpt1        = "Instalar Office (descarga automatica)"
    MenuOpt1Desc    = "Descarga e instala Microsoft Office desde servidores oficiales"
    MenuOpt2        = "Activar Office"
    MenuOpt2Desc    = "Activa Microsoft Office permanentemente (Ohook)"
    MenuOpt3        = "Reparar Office"
    MenuOpt3Desc    = "Repara componentes danados y errores de configuracion"
    MenuOpt4        = "Desinstalar Office"
    MenuOpt4Desc    = "Elimina completamente Microsoft Office del sistema"
    MenuOpt5        = "Activar Windows"
    MenuOpt5Desc    = "Obten licencia digital permanente para Windows 10/11"
    MenuOpt6        = "Ver estado de activacion"
    MenuOpt6Desc    = "Comprueba si Windows y Office estan activados"
    MenuOpt7        = "Solucion de problemas"
    MenuOpt7Desc    = "Herramientas avanzadas de diagnostico y reparacion"
    MenuOpt8        = "Informacion del sistema"
    MenuOpt8Desc    = "Muestra informacion detallada de tu hardware y software"
    MenuOpt0        = "SALIR"
    MenuFooter      = "Elige el numero de la opcion que deseas realizar"

    InstallMenuTitle = "INSTALAR OFFICE"
    InstallMenuSub   = "Selecciona la version"
    InstallFooter    = "Todas las versiones se descargan de servidores oficiales de Microsoft"
    InstallNote      = "Despues de instalar, usa [2] Activar Office"
}

# ============================================
# FUNCIONES
# ============================================
function Write-Log {
    param([string]$M)
    $t = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$t] $M" | Out-File -FilePath $LogFile -Append -Encoding UTF8
}

function Test-Internet {
    try { return (Test-Connection 8.8.8.8 -Count 1 -Quiet) } catch { return $false }
}

function Banner {
    param([string]$Ttl = "", [string]$Sub = "")
    Clear-Host
    Write-Host ""
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan
    Write-Host "  |                                                      |" -ForegroundColor $C.Cyan
    $padding = 52 - $Ttl.Length
    $left = [math]::Floor($padding / 2)
    Write-Host "  |" -ForegroundColor $C.Cyan -NoNewline
    Write-Host (" " * $left) -NoNewline
    Write-Host $Ttl -ForegroundColor $C.White -NoNewline
    Write-Host (" " * ($padding - $left + 2)) -NoNewline
    Write-Host "|" -ForegroundColor $C.Cyan
    if ($Sub) {
        $padding2 = 52 - $Sub.Length
        $left2 = [math]::Floor($padding2 / 2)
        Write-Host "  |" -ForegroundColor $C.Cyan -NoNewline
        Write-Host (" " * $left2) -NoNewline
        Write-Host $Sub -ForegroundColor $C.Gray -NoNewline
        Write-Host (" " * ($padding2 - $left2 + 2)) -NoNewline
        Write-Host "|" -ForegroundColor $C.Cyan
    }
    Write-Host "  |                                                      |" -ForegroundColor $C.Cyan
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.BannerBy)  |  MAS massgrave.dev  |  $($MSG.BannerVersion)" -ForegroundColor $C.DarkGray
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.DarkGray
    Write-Host ""
}

function Step {
    param([string]$M, [string]$S = "info")
    switch ($S) {
        "success"  { Write-Host "    [OK]  $M" -ForegroundColor $C.Green }
        "warning"  { Write-Host "    [!]   $M" -ForegroundColor $C.Yellow }
        "error"    { Write-Host "    [X]   $M" -ForegroundColor $C.Red }
        "info"     { Write-Host "    [i]   $M" -ForegroundColor $C.Gray }
        "progress" { Write-Host "    [*]   $M" -ForegroundColor $C.Magenta }
    }
}

function Pause-Menu {
    Write-Host ""
    Write-Host "  $($MSG.PressBack)" -ForegroundColor $C.Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ============================================
# INSTALAR OFFICE
# ============================================
function Start-OfficeInstall {
    param([string]$ProductID, [string]$VersionName)

    Banner -Ttl $MSG.InstallingTitle -Sub $VersionName

    if (-not (Test-Internet)) {
        Step $MSG.NoInternet -S "error"
        Pause-Menu
        return
    }
    Step $MSG.InternetOK -S "success"

    # Detectar arquitectura
    if ([Environment]::Is64BitOperatingSystem) {
        $arch = "x64"
    } else {
        $arch = "x86"
    }
    Step "Arquitectura detectada: $arch" -S "info"

    Step $MSG.CheckingDisk -S "progress"
    $disk = Get-PSDrive -Name C
    $free = [math]::Round($disk.Free / 1GB, 1)
    if ($free -lt 10) {
        Step "$($MSG.DiskLow) ($free GB libres). $($MSG.Need10GB)" -S "error"
        Pause-Menu
        return
    }
    Step "$($MSG.DiskOK): $free GB" -S "success"

    Write-Host ""
    Step $MSG.Downloading -S "progress"

    $url = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=$ProductID&platform=$arch&language=es-es&version=O16GA"
    $instPath = "$env:TEMP\OfficeSetup_$ProductID.exe"

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        Invoke-WebRequest -Uri $url -OutFile $instPath -UseBasicParsing -ErrorAction Stop

        if (Test-Path $instPath) {
            $sz = [math]::Round((Get-Item $instPath).Length / 1MB, 2)
            Step "$($MSG.Downloaded) ($sz MB)" -S "success"
        } else {
            throw "El archivo no se descargo correctamente."
        }

        Write-Host ""
        Step $MSG.RunningSetup -S "progress"
        Step $MSG.SetupInfo -S "info"
        Step $MSG.SetupInfo2 -S "info"
        Step $MSG.SetupInfo3 -S "warning"
        Write-Host ""

        Start-Process -FilePath $instPath -Wait

        Write-Host ""
        Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Green
        Write-Host "  |  $($MSG.InstallDone)" -ForegroundColor $C.Green
        Write-Host "  |  $($MSG.InstallDoneMsg)" -ForegroundColor $C.White
        Write-Host "  |" -ForegroundColor $C.Green -NoNewline
        Write-Host (" " * 54) -NoNewline
        Write-Host "|" -ForegroundColor $C.Green
        Write-Host "  |  [!]  $($MSG.ActivateAfter)" -ForegroundColor $C.Yellow
        Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Green
        Write-Log "Office installed: $VersionName"
        Remove-Item $instPath -ErrorAction SilentlyContinue

    } catch {
        Write-Host ""
        Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Red
        Write-Host "  |  $($MSG.InstallError)" -ForegroundColor $C.Red
        Write-Host "  |  $($_.Exception.Message)" -ForegroundColor $C.White
        Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Red
        Write-Log "Install error: $($_.Exception.Message)"
        Remove-Item $instPath -ErrorAction SilentlyContinue
    }

    Pause-Menu
}

# ============================================
# ACTIVAR OFFICE
# ============================================
function Start-OfficeActivation {
    Banner -Ttl $MSG.ActivatingTitle

    Step $MSG.CheckingOffice -S "progress"
    $offCheck = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\winword.exe",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\winword.exe"
    )
    $found = $false
    foreach ($path in $offCheck) {
        $off = Get-ItemProperty $path -ErrorAction SilentlyContinue
        if ($off -and $off.'(Default)' -and (Test-Path $off.'(Default)')) {
            $found = $true
            break
        }
    }

    if (-not $found) {
        Step $MSG.NoOffice -S "error"
        Step "Primero instala Office con la opcion [1]" -S "warning"
        Pause-Menu
        return
    }
    Step $MSG.OfficeFound -S "success"

    Write-Host ""
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Yellow
    Write-Host "  |  $($MSG.ActInstrTitle)" -ForegroundColor $C.Yellow
    Write-Host "  |" -ForegroundColor $C.Yellow -NoNewline
    Write-Host (" " * 54) -NoNewline
    Write-Host "|" -ForegroundColor $C.Yellow
    Write-Host "  |  $($MSG.ActInstr1)" -ForegroundColor $C.White
    Write-Host "  |  $($MSG.ActInstr2)" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.ActInstr3)" -ForegroundColor $C.White
    Write-Host "  |  $($MSG.ActInstr4)" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.ActInstr5)" -ForegroundColor $C.White
    Write-Host "  |  $($MSG.ActInstr6)" -ForegroundColor $C.Green
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Yellow
    Write-Host ""
    Step $MSG.ActRunning -S "progress"
    try { Invoke-Expression (Invoke-RestMethod https://get.activated.win) } catch { Step "Error: $($_.Exception.Message)" -S "error" }

    Write-Host ""
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Green
    Write-Host "  |  $($MSG.ActSuccess)" -ForegroundColor $C.Green
    Write-Host "  |  $($MSG.ActSuccessMsg)" -ForegroundColor $C.White
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Green
    Pause-Menu
}

# ============================================
# ACTIVAR WINDOWS
# ============================================
function Start-WindowsActivation {
    Banner -Ttl $MSG.WinActTitle
    if (-not (Test-Internet)) { Step $MSG.NoInternet -S "error"; Pause-Menu; return }

    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Yellow
    Write-Host "  |  $($MSG.WinInstrTitle)" -ForegroundColor $C.Yellow
    Write-Host "  |" -ForegroundColor $C.Yellow -NoNewline
    Write-Host (" " * 54) -NoNewline
    Write-Host "|" -ForegroundColor $C.Yellow
    Write-Host "  |  $($MSG.WinInstr1)" -ForegroundColor $C.White
    Write-Host "  |  $($MSG.WinInstr2)" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.WinInstr3)" -ForegroundColor $C.White
    Write-Host "  |  $($MSG.WinInstr4)" -ForegroundColor $C.Gray
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Yellow
    Write-Host ""
    Step $MSG.WinRunning -S "progress"
    try { Invoke-Expression (Invoke-RestMethod https://get.activated.win) } catch { Step "Error: $($_.Exception.Message)" -S "error" }

    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Green
    Write-Host "  |  $($MSG.WinSuccess)" -ForegroundColor $C.Green
    Write-Host "  |  $($MSG.WinSuccessMsg)" -ForegroundColor $C.White
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Green
    Pause-Menu
}

# ============================================
# REPARAR OFFICE
# ============================================
function Start-OfficeRepair {
    Banner -Ttl $MSG.RepairTitle

    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Yellow
    Write-Host "  |  INSTRUCCIONES PARA REPARAR OFFICE" -ForegroundColor $C.Yellow
    Write-Host "  |" -ForegroundColor $C.Yellow -NoNewline
    Write-Host (" " * 54) -NoNewline
    Write-Host "|" -ForegroundColor $C.Yellow
    Write-Host "  |  $($MSG.RepairInstr1)" -ForegroundColor $C.White
    Write-Host "  |  $($MSG.RepairInstr2)" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.RepairInstr3)" -ForegroundColor $C.White
    Write-Host "  |  $($MSG.RepairInstr4)" -ForegroundColor $C.Cyan
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Yellow
    Write-Host ""
    Step $MSG.RepairRunning -S "progress"
    try { Invoke-Expression (Invoke-RestMethod https://get.activated.win) } catch { Step "Error: $($_.Exception.Message)" -S "error" }
    Pause-Menu
}

# ============================================
# DESINSTALAR OFFICE - METODO ROBUSTO MULTIETAPA
# ============================================
function Start-OfficeUninstall {
    Banner -Ttl $MSG.UninstallTitle

    Step $MSG.UninstallScan -S "progress"

    $officeProducts = @()

    # ---- Buscar en el registro de desinstalacion (32 y 64 bit) ----
    $uninstallPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    foreach ($path in $uninstallPaths) {
        if (-not (Test-Path $path)) { continue }
        $keys = Get-ChildItem $path -ErrorAction SilentlyContinue
        foreach ($key in $keys) {
            try {
                $props = Get-ItemProperty -Path $key.PSPath -ErrorAction SilentlyContinue
                $displayName = $props.DisplayName
                if (-not $displayName) { continue }

                # Detectar Office 2016/2019/2021/2024 y Microsoft 365 (C2R y MSI)
                $isOffice = (
                    $displayName -like "*Microsoft Office*"        -or
                    $displayName -like "*Microsoft 365*"           -or
                    $displayName -like "*Office 16*"               -or
                    $displayName -like "*Office 19*"               -or
                    $displayName -like "*Office 21*"               -or
                    $displayName -like "*Office 24*"               -or
                    $displayName -like "*Microsoft Word*"          -or
                    $displayName -like "*Microsoft Excel*"         -or
                    $displayName -like "*Microsoft PowerPoint*"    -or
                    $displayName -like "*Microsoft Outlook*"       -or
                    $displayName -like "*Microsoft Access*"
                )

                # Excluir entradas que no son la suite principal (drivers, OneDrive, etc.)
                $isExcluded = (
                    $displayName -like "*OneDrive*"                -or
                    $displayName -like "*Teams*"                   -or
                    $displayName -like "*Skype*"                   -or
                    $displayName -like "*Visual Studio*"
                )

                if ($isOffice -and -not $isExcluded) {
                    $officeProducts += @{
                        Name      = $displayName
                        Version   = $props.DisplayVersion
                        Uninstall = $props.UninstallString
                        GUID      = $key.PSChildName
                        Path      = $key.PSPath
                    }
                }
            } catch {
                Write-Log "Could not read key: $($key.PSPath)"
            }
        }
    }

    # ---- Tambien buscar via ClickToRun aunque no aparezca en ARP ----
    $c2rConfigPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration"
    )
    $c2rDetected = $false
    foreach ($cp in $c2rConfigPaths) {
        if (Test-Path $cp) {
            $c2rProps = Get-ItemProperty $cp -ErrorAction SilentlyContinue
            if ($c2rProps -and $c2rProps.ProductReleaseIds) {
                $c2rDetected = $true
                # Si el registro C2R existe pero no aparecio en ARP, agregar entrada sintetica
                $alreadyFound = $officeProducts | Where-Object { $_.Name -like "*Office*" -or $_.Name -like "*365*" }
                if (-not $alreadyFound) {
                    $officeProducts += @{
                        Name      = "Microsoft Office (Click-to-Run) - $($c2rProps.ProductReleaseIds)"
                        Version   = $c2rProps.VersionToReport
                        Uninstall = ""
                        GUID      = "C2R"
                        Path      = $cp
                    }
                }
                break
            }
        }
    }

    # ---- Eliminar duplicados por nombre ----
    $seen = @{}
    $unique = @()
    foreach ($prod in $officeProducts) {
        if ($prod.Name -and -not $seen.ContainsKey($prod.Name)) {
            $seen[$prod.Name] = $true
            $unique += $prod
        }
    }
    $officeProducts = $unique

    # ---- Si no se encontro nada ----
    if ($officeProducts.Count -eq 0) {
        Write-Host ""
        Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Yellow
        Write-Host "  |  $($MSG.UninstallNone)" -ForegroundColor $C.Yellow
        Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Yellow
        Write-Host ""
        Write-Host "  [i]  Tambien puedes desinstalar desde: Configuracion > Aplicaciones" -ForegroundColor $C.Gray
        Pause-Menu
        return
    }

    # ---- Mostrar productos encontrados ----
    Write-Host ""
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.UninstallFound)" -ForegroundColor $C.Cyan
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan
    Write-Host ""

    $i = 1
    foreach ($prod in $officeProducts) {
        Write-Host "  [$i]  $($prod.Name)" -ForegroundColor $C.White
        if ($prod.Version) { Write-Host "       Version: $($prod.Version)" -ForegroundColor $C.Gray }
        Write-Host ""
        $i++
    }

    Write-Host "  $($MSG.UninstallWhich)" -ForegroundColor $C.White
    Write-Host "  $($MSG.UninstallAll)" -ForegroundColor $C.Red
    Write-Host "  $($MSG.UninstallCancel)" -ForegroundColor $C.Green
    Write-Host ""
    $choice = Read-Host "  Elige (0-1)"

    if ($choice -eq "1") {

        $anySuccess = $false

        # ==============================================================
        # PASO 0: Cerrar todos los procesos de Office antes de desinstalar
        # ==============================================================
        Write-Host ""
        Write-Host "    [*]  Cerrando procesos de Office..." -ForegroundColor $C.Magenta
        $officeProcs = @("WINWORD","EXCEL","POWERPNT","OUTLOOK","ONENOTE","MSACCESS","MSPUB",
                         "LYNC","Teams","OfficeClickToRun","AppVShNotify","OfficeC2RClient",
                         "MsoSync","msoia","groove","INFOPATH","VISIO","MSPROJ")
        foreach ($pn in $officeProcs) {
            Get-Process -Name $pn -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        }
        Start-Sleep -Seconds 2
        Step "Procesos de Office cerrados" -S "success"

        # ==============================================================
        # METODO 1 (PRINCIPAL): ODT - Office Deployment Tool descargado desde Microsoft
        # Este es el metodo OFICIAL y el mismo que usa Windows internamente
        # ==============================================================
        Write-Host ""
        Write-Host "  $($MSG.Uninstalling): Microsoft Office (ODT - Metodo Oficial)..." -ForegroundColor $C.Yellow
        Write-Log "Method 1: ODT officescrubber / setup.exe /configure Remove"

        $odtDir  = "$env:TEMP\ODT_Uninstall"
        $odtExe  = "$odtDir\setup.exe"
        $odtXml  = "$odtDir\remove.xml"
        $odtUrl  = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_18324-20194.exe"
        $odtSuccess = $false

        if (-not (Test-Path $odtDir)) { New-Item -ItemType Directory -Path $odtDir -Force | Out-Null }

        # Primero intentar con setup.exe local si ya existe
        $localSetupPaths = @(
            "$env:ProgramFiles\Microsoft Office\root\Office16\SETUP.EXE",
            "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\SETUP.EXE",
            "$env:ProgramFiles\Microsoft Office\Office16\SETUP.EXE",
            "${env:ProgramFiles(x86)}\Microsoft Office\Office16\SETUP.EXE"
        )
        $localSetup = $null
        foreach ($sp in $localSetupPaths) { if (Test-Path $sp) { $localSetup = $sp; break } }

        # XML de desinstalacion total
        $removeXml = @"
<Configuration>
  <Remove All="TRUE" />
  <Display Level="Full" AcceptEULA="TRUE" />
  <Property Name="FORCEAPPSHUTDOWN" Value="TRUE" />
  <Property Name="SharedComputerLicensing" Value="0" />
</Configuration>
"@
        $removeXml | Out-File -FilePath $odtXml -Encoding UTF8 -Force

        # Intentar con setup.exe local primero (mas rapido, sin descarga)
        if ($localSetup) {
            Write-Host "    [*]  Intentando con setup.exe local + XML Remove All..." -ForegroundColor $C.Magenta
            Write-Log "Method 1a: Local setup.exe /configure $odtXml"
            try {
                $proc = Start-Process -FilePath $localSetup -ArgumentList "/configure `"$odtXml`"" -Wait -PassThru -NoNewWindow -ErrorAction Stop
                Write-Log "Local setup.exe ExitCode: $($proc.ExitCode)"
                if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) {
                    $odtSuccess = $true
                    $anySuccess = $true
                    Step "Desinstalacion via setup.exe local completada (codigo: $($proc.ExitCode))" -S "success"
                } else {
                    Write-Log "Local setup.exe returned: $($proc.ExitCode)"
                }
            } catch {
                Write-Log "Local setup.exe error: $($_.Exception.Message)"
            }
        }

        # Si el local fallo, descargar ODT oficial de Microsoft y usarlo
        if (-not $odtSuccess) {
            if (Test-Internet) {
                Write-Host "    [*]  Descargando ODT oficial de Microsoft..." -ForegroundColor $C.Magenta
                Write-Log "Method 1b: Downloading ODT from Microsoft"
                try {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                    $odtPkg = "$odtDir\odt.exe"
                    Invoke-WebRequest -Uri $odtUrl -OutFile $odtPkg -UseBasicParsing -ErrorAction Stop
                    # Extraer ODT
                    $extractProc = Start-Process -FilePath $odtPkg -ArgumentList "/quiet /extract:`"$odtDir`"" -Wait -PassThru -ErrorAction Stop
                    Start-Sleep -Seconds 3
                    if (Test-Path $odtExe) {
                        Write-Host "    [*]  ODT descargado. Ejecutando desinstalacion completa..." -ForegroundColor $C.Magenta
                        Write-Log "Method 1b: Running ODT setup.exe /configure remove.xml"
                        $proc = Start-Process -FilePath $odtExe -ArgumentList "/configure `"$odtXml`"" -Wait -PassThru -NoNewWindow -ErrorAction Stop
                        Write-Log "ODT ExitCode: $($proc.ExitCode)"
                        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) {
                            $odtSuccess = $true
                            $anySuccess = $true
                            Step "Desinstalacion via ODT completada (codigo: $($proc.ExitCode))" -S "success"
                        } else {
                            Write-Log "ODT returned: $($proc.ExitCode)"
                        }
                    }
                } catch {
                    Write-Log "ODT download/run error: $($_.Exception.Message)"
                }
            } else {
                Write-Log "No internet for ODT download"
            }
        }
        Remove-Item $odtDir -Recurse -Force -ErrorAction SilentlyContinue

        # ==============================================================
        # METODO 2: OfficeC2RClient.exe con todos los ProductIDs conocidos
        # ==============================================================
        if (-not $anySuccess) {
            Write-Host ""
            Write-Host "    [!]  ODT no disponible. Intentando via ClickToRun directo..." -ForegroundColor $C.Yellow
            Write-Log "Method 2: OfficeC2RClient.exe"

            $c2rClientExes = @(
                "${env:CommonProgramFiles}\Microsoft Shared\ClickToRun\OfficeC2RClient.exe",
                "${env:CommonProgramFiles(x86)}\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
            )
            $c2rClient = $null
            foreach ($e in $c2rClientExes) { if (Test-Path $e) { $c2rClient = $e; break } }

            # Obtener ProductReleaseIds reales del registro para desinstalar exactamente lo instalado
            $productIds = @()
            $c2rRegPaths = @(
                "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration",
                "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration"
            )
            foreach ($rp in $c2rRegPaths) {
                if (Test-Path $rp) {
                    $rv = Get-ItemProperty $rp -ErrorAction SilentlyContinue
                    if ($rv -and $rv.ProductReleaseIds) {
                        $productIds = $rv.ProductReleaseIds -split ","
                        Write-Log "Found ProductReleaseIds: $($rv.ProductReleaseIds)"
                        break
                    }
                }
            }
            # Lista de fallback si no se encontro en el registro
            if ($productIds.Count -eq 0) {
                $productIds = @("ProPlus2019Retail","ProPlus2021Retail","ProPlus2024Retail",
                                "O365ProPlusRetail","Professional2019Retail","ProPlusRetail",
                                "HomeBusiness2019Retail","HomeStudent2019Retail")
            }

            if ($c2rClient) {
                foreach ($pid2 in $productIds) {
                    Write-Host "    [*]  Desinstalando: $pid2 ..." -ForegroundColor $C.Magenta
                    try {
                        $proc = Start-Process -FilePath $c2rClient -ArgumentList "/uninstall $pid2 /quiet" -Wait -PassThru -NoNewWindow -ErrorAction Stop
                        Write-Log "OfficeC2RClient /uninstall $pid2 ExitCode: $($proc.ExitCode)"
                        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) {
                            $anySuccess = $true
                            Step "Desinstalado: $pid2 (codigo: $($proc.ExitCode))" -S "success"
                        }
                    } catch {
                        Write-Log "OfficeC2RClient error ($pid2): $($_.Exception.Message)"
                    }
                }
            }
        }

        # ==============================================================
        # METODO 3: msiexec /x por GUID desde el registro (MSI clasico)
        # ==============================================================
        if (-not $anySuccess) {
            Write-Host ""
            Write-Host "    [!]  Intentando desinstalacion via MSI (registro)..." -ForegroundColor $C.Yellow
            Write-Log "Method 3: msiexec /x from registry"
            $anyMsiOk = $false
            foreach ($prod in $officeProducts) {
                $msiOk = $false
                $guidToUse = $null
                if ($prod.Uninstall -and $prod.Uninstall -match "msiexec") {
                    $gm = [regex]::Match($prod.Uninstall, "(\{[0-9A-Fa-f\-]+\})")
                    if ($gm.Success) { $guidToUse = $gm.Groups[1].Value }
                } elseif ($prod.GUID -match "^\{[0-9A-Fa-f\-]+\}$") {
                    $guidToUse = $prod.GUID
                }
                if ($guidToUse) {
                    Write-Host "    [*]  msiexec /x $guidToUse ..." -ForegroundColor $C.Magenta
                    try {
                        $p3 = Start-Process "msiexec.exe" -ArgumentList "/x $guidToUse /quiet /norestart" -Wait -PassThru -NoNewWindow -ErrorAction Stop
                        Write-Log "msiexec /x $guidToUse ExitCode: $($p3.ExitCode)"
                        if ($p3.ExitCode -eq 0 -or $p3.ExitCode -eq 3010 -or $p3.ExitCode -eq 1605) {
                            $msiOk = $true; $anyMsiOk = $true; $anySuccess = $true
                            Step "OK - $($prod.Name)" -S "success"
                        }
                    } catch { Write-Log "msiexec error: $($_.Exception.Message)" }
                }
                if (-not $msiOk) { Write-Log "MSI failed for: $($prod.Name)" }
            }
        }

        # ==============================================================
        # METODO 4 (NUCLEAR): Borrado forzado de archivos y claves de registro
        # Se ejecuta si todos los metodos anteriores fallaron
        # ==============================================================
        if (-not $anySuccess) {
            Write-Host ""
            Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Red
            Write-Host "  |  [NUCLEAR] Eliminacion forzada de archivos y registro |" -ForegroundColor $C.Red
            Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Red
            Write-Log "Method 4: NUCLEAR forced removal"

            # Matar servicios de Office
            $officeServices = @("ClickToRunSvc","OfficeSvc","MsoSync","OfficeFileCache")
            foreach ($svc in $officeServices) {
                $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
                if ($s) {
                    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
                    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
                    Write-Log "Stopped service: $svc"
                }
            }

            # Matar procesos residuales otra vez
            foreach ($pn in $officeProcs) {
                Get-Process -Name $pn -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
            }
            Start-Sleep -Seconds 2

            # Borrar carpetas de Office
            $officeFolders = @(
                "$env:ProgramFiles\Microsoft Office",
                "${env:ProgramFiles(x86)}\Microsoft Office",
                "${env:CommonProgramFiles}\Microsoft Shared\ClickToRun",
                "${env:CommonProgramFiles(x86)}\Microsoft Shared\ClickToRun",
                "${env:CommonProgramFiles}\Microsoft Shared\OFFICE16",
                "${env:CommonProgramFiles(x86)}\Microsoft Shared\OFFICE16",
                "$env:LOCALAPPDATA\Microsoft\Office",
                "$env:APPDATA\Microsoft\Office",
                "$env:ProgramData\Microsoft\Office"
            )
            $deletedFolders = 0
            foreach ($folder in $officeFolders) {
                if (Test-Path $folder) {
                    Write-Host "    [*]  Borrando: $folder" -ForegroundColor $C.Magenta
                    try {
                        # Quitar atributos de solo lectura primero
                        Get-ChildItem -Path $folder -Recurse -Force -ErrorAction SilentlyContinue |
                            ForEach-Object { $_.Attributes = 'Normal' }
                        Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
                        $deletedFolders++
                        Write-Log "Deleted folder: $folder"
                    } catch {
                        Write-Log "Could not delete folder: $folder - $($_.Exception.Message)"
                    }
                }
            }

            # Borrar claves de registro de Office
            $officeRegKeys = @(
                "HKLM:\SOFTWARE\Microsoft\Office",
                "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office",
                "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\O365ProPlusRetail - es-es",
                "HKCU:\SOFTWARE\Microsoft\Office"
            )
            # Borrar entradas ARP (Agregar/Quitar Programas) de Office detectadas
            foreach ($prod in $officeProducts) {
                if ($prod.Path) {
                    $officeRegKeys += $prod.Path
                }
            }
            $deletedKeys = 0
            foreach ($regKey in $officeRegKeys) {
                if (Test-Path $regKey) {
                    Write-Host "    [*]  Borrando registro: $regKey" -ForegroundColor $C.Magenta
                    try {
                        Remove-Item -Path $regKey -Recurse -Force -ErrorAction SilentlyContinue
                        $deletedKeys++
                        Write-Log "Deleted registry key: $regKey"
                    } catch {
                        Write-Log "Could not delete registry key: $regKey"
                    }
                }
            }

            # Borrar accesos directos del Menu de Inicio
            $startMenuPaths = @(
                "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Microsoft Office",
                "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs",
                "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Microsoft Office"
            )
            foreach ($sm in $startMenuPaths) {
                if (Test-Path $sm) {
                    Get-ChildItem -Path $sm -Filter "*.lnk" -ErrorAction SilentlyContinue |
                        Where-Object { $_.Name -match "Word|Excel|PowerPoint|Outlook|Access|OneNote|Publisher|Office" } |
                        Remove-Item -Force -ErrorAction SilentlyContinue
                }
            }

            if ($deletedFolders -gt 0 -or $deletedKeys -gt 0) {
                $anySuccess = $true
                Step "Eliminacion forzada completada ($deletedFolders carpetas, $deletedKeys claves de registro)" -S "success"
                Write-Log "Nuclear removal: $deletedFolders folders, $deletedKeys registry keys deleted"
            } else {
                Write-Host ""
                Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Red
                Write-Host "  |  $($MSG.UninstallFail)" -ForegroundColor $C.Red
                Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Red
                Write-Host ""
                Write-Host "  [i]  Usa la herramienta oficial de Microsoft para desinstalar:" -ForegroundColor $C.Gray
                Write-Host "       https://aka.ms/SaRA-OfficeUninstallFromPC" -ForegroundColor $C.Cyan
                Write-Log "All methods failed."
                Pause-Menu
                return
            }
        }

        Write-Host ""
        Step $MSG.UninstallDone -S "success"
        Step "Recomendamos reiniciar el equipo para completar la desinstalacion" -S "info"
        Write-Log "Uninstall process completed."

    } elseif ($choice -eq "0") {
        Step "Cancelado" -S "info"
    } else {
        Step $MSG.Invalid -S "error"
    }

    Pause-Menu
}

# ============================================
# VERIFICAR ESTADO - CORREGIDO
# ============================================
function Show-CheckStatus {
    Banner -Ttl $MSG.CheckTitle

    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.CheckWin)" -ForegroundColor $C.Cyan
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan

    try {
        $slmgrOutput = & cscript //Nologo "$env:SystemRoot\System32\slmgr.vbs" /xpr 2>&1
        $slmgrText = ($slmgrOutput -join " ").ToLower()
        
        # Verificar tambien con /dli para obtener estado mas detallado
        $slmgrDli = & cscript //Nologo "$env:SystemRoot\System32\slmgr.vbs" /dli 2>&1
        $slmgrDliText = ($slmgrDli -join " ").ToLower()

        if ($slmgrText -match "permanentemente" -or $slmgrText -match "permanently" -or $slmgrText -match "permanently activated") {
            Write-Host "  |  Estado: $($MSG.CheckActivated)" -ForegroundColor $C.Green
            Write-Host "  |  Tipo: $($MSG.CheckPermanent)" -ForegroundColor $C.Green
        } elseif ($slmgrDliText -match "license status.*licensed" -or $slmgrDliText -match "estado de licencia.*con licencia") {
            Write-Host "  |  Estado: $($MSG.CheckActivated)" -ForegroundColor $C.Green
            if ($slmgrDliText -match "kms") {
                Write-Host "  |  Tipo: $($MSG.CheckKMS)" -ForegroundColor $C.Yellow
            } else {
                Write-Host "  |  Tipo: $($MSG.CheckPermanent)" -ForegroundColor $C.Green
            }
        } elseif ($slmgrText -match "activado" -or $slmgrText -match "licensed" -or $slmgrText -match "windows is activated") {
            Write-Host "  |  Estado: $($MSG.CheckActivated)" -ForegroundColor $C.Green
            if ($slmgrText -match "kms") {
                Write-Host "  |  Tipo: $($MSG.CheckKMS)" -ForegroundColor $C.Yellow
            }
        } elseif ($slmgrText -match "grace" -or $slmgrText -match "gracia") {
            Write-Host "  |  Estado: $($MSG.CheckGrace)" -ForegroundColor $C.Yellow
        } elseif ($slmgrText -match "notification" -or $slmgrText -match "notificacion") {
            Write-Host "  |  Estado: $($MSG.CheckNotAct)" -ForegroundColor $C.Red
        } else {
            # Fallback: verificar con Get-CimInstance
            try {
                $licStatus = (Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%' AND LicenseStatus=1" -ErrorAction Stop | Select-Object -First 1)
                if ($licStatus) {
                    Write-Host "  |  Estado: $($MSG.CheckActivated)" -ForegroundColor $C.Green
                } else {
                    Write-Host "  |  Estado: $($MSG.CheckNotAct)" -ForegroundColor $C.Red
                }
            } catch {
                Write-Host "  |  Estado: $($MSG.CheckUnknown)" -ForegroundColor $C.Gray
            }
        }
    } catch {
        Write-Host "  |  Estado: $($MSG.CheckUnknown)" -ForegroundColor $C.Gray
        Write-Log "Windows status check error: $($_.Exception.Message)"
    }

    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan
    Write-Host ""
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.CheckOffice)" -ForegroundColor $C.Cyan
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan

    $osppPath = $null
    $possiblePaths = @(
        "$env:ProgramFiles\Microsoft Office\Office16\ospp.vbs",
        "${env:ProgramFiles(x86)}\Microsoft Office\Office16\ospp.vbs",
        "$env:ProgramFiles\Microsoft Office\root\Office16\ospp.vbs",
        "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\ospp.vbs"
    )

    foreach ($path in $possiblePaths) {
        if (Test-Path $path) { $osppPath = $path; break }
    }

    if ($osppPath) {
        try {
            $osppOutput = & cscript //Nologo $osppPath /dstatus 2>&1
            # Unir lineas con salto de linea para preservar estructura
            $osppText = ($osppOutput -join "`n")

            # Detectar estado: buscar en cada linea individualmente para mayor precision
            $isLicensed       = $osppOutput | Where-Object { $_ -match "LICENSE STATUS.*LICENSED" -and $_ -notmatch "OOB_GRACE" -and $_ -notmatch "NOTIFICATIONS" }
            $isOobGrace       = $osppOutput | Where-Object { $_ -match "LICENSE STATUS.*OOB_GRACE" }
            $isNotifications  = $osppOutput | Where-Object { $_ -match "LICENSE STATUS.*NOTIFICATIONS" }
            $isNonGenuine     = $osppOutput | Where-Object { $_ -match "LICENSE STATUS.*NON_GENUINE" }

            # Tambien verificar activacion por Ohook (MAS): DLL en disco
            $ohookPaths = @(
                "$env:ProgramFiles\Microsoft Office\root\Office16\AppSharingHookController64.dll",
                "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\AppSharingHookController64.dll",
                "$env:SystemRoot\System32\sppc.dll"
            )
            # Verificar la clave de registro de Ohook
            $ohookRegPaths = @(
                "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration",
                "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration"
            )
            $ohookActive = $false
            # Verificar si ospp reporta LICENSED (cualquier producto)
            if ($isLicensed) {
                $ohookActive = $true
            }
            # Verificar clave de registro de Ohook/MAS
            foreach ($regP in $ohookRegPaths) {
                if (Test-Path $regP) {
                    $regV = Get-ItemProperty $regP -ErrorAction SilentlyContinue
                    if ($regV -and ($regV.SharedComputerLicensing -eq 1 -or $regV.OfficeMgmtCOM -eq 1)) {
                        $ohookActive = $true
                    }
                }
            }
            # Verificar archivo de licencia Ohook en disco
            $ohookDll = "$env:SystemRoot\System32\sppc.dll"
            $ohookDll2 = "${env:CommonProgramFiles}\Microsoft Shared\ClickToRun\MsoHookManager.dll"
            if (Test-Path $ohookDll2) { $ohookActive = $true }

            # Mostrar estado segun deteccion
            if ($isLicensed -or $ohookActive) {
                Write-Host "  |  Estado: $($MSG.CheckActivated)" -ForegroundColor $C.Green
                # Verificar si es KMS
                $isKms = $osppOutput | Where-Object { $_ -match "KMS" }
                if ($isKms) {
                    Write-Host "  |  Tipo: $($MSG.CheckKMS)" -ForegroundColor $C.Yellow
                } else {
                    Write-Host "  |  Tipo: Activado (Ohook/MAS)" -ForegroundColor $C.Green
                }
            } elseif ($isOobGrace) {
                Write-Host "  |  Estado: $($MSG.CheckGrace)" -ForegroundColor $C.Yellow
                $graceMatch = $osppOutput | Where-Object { $_ -match "REMAINING GRACE" }
                if ($graceMatch) {
                    if ($graceMatch -match "(\d+)\s*day") {
                        $days = $Matches[1]
                        Write-Host "  |  Dias restantes: $days dias (usa opcion 2 para activar)" -ForegroundColor $C.Yellow
                    }
                }
            } elseif ($isNotifications -or $isNonGenuine) {
                Write-Host "  |  Estado: $($MSG.CheckNotAct)" -ForegroundColor $C.Red
            } else {
                # No se encontro estado definitivo: verificar si hay productos pero sin estado claro
                $anyProduct = $osppOutput | Where-Object { $_ -match "LICENSE NAME" }
                if ($anyProduct) {
                    Write-Host "  |  Estado: $($MSG.CheckActivated)" -ForegroundColor $C.Green
                    Write-Host "  |  Tipo: Licencia detectada" -ForegroundColor $C.Green
                } else {
                    Write-Host "  |  Estado: $($MSG.CheckUnknown)" -ForegroundColor $C.Gray
                }
            }

            # Mostrar productos detectados
            $lines = $osppOutput | Where-Object { $_ -match "SKU ID|LICENSE NAME|LICENSE STATUS" }
            if ($lines) {
                Write-Host "  |" -ForegroundColor $C.Cyan
                Write-Host "  |  Productos detectados:" -ForegroundColor $C.White
                foreach ($line in $lines) {
                    Write-Host "  |    $($line.Trim())" -ForegroundColor $C.Gray
                }
            }

            # Mostrar advertencia solo si realmente esta en gracia
            if ($isOobGrace -and -not $isLicensed) {
                Write-Host "  |" -ForegroundColor $C.Cyan
                Write-Host "  |  [!]  Office esta en PERIODO DE GRACIA (no activado)" -ForegroundColor $C.Yellow
                Write-Host "  |       Usa la opcion [2] Activar Office para activarlo permanentemente" -ForegroundColor $C.Gray
            }
        } catch {
            Write-Host "  |  Estado: $($MSG.CheckUnknown)" -ForegroundColor $C.Gray
            Write-Log "Office status check error: $($_.Exception.Message)"
        }
    } else {
        $wordPaths = @(
            "$env:ProgramFiles\Microsoft Office\root\Office16\WINWORD.EXE",
            "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\WINWORD.EXE",
            "$env:ProgramFiles\Microsoft Office\Office16\WINWORD.EXE",
            "${env:ProgramFiles(x86)}\Microsoft Office\Office16\WINWORD.EXE"
        )
        $wordFound = $false
        foreach ($wp in $wordPaths) {
            if (Test-Path $wp) { $wordFound = $true; break }
        }

        if ($wordFound) {
            Write-Host "  |  Office: $($MSG.SysInfoOFFInst)" -ForegroundColor $C.Green
            Write-Host "  |  Usa la opcion [2] Activar Office para activarlo" -ForegroundColor $C.Yellow
        } else {
            Write-Host "  |  Office: $($MSG.SysInfoOFFNo)" -ForegroundColor $C.Red
        }
    }

    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan
    Write-Host ""
    Pause-Menu
}

# ============================================
# SOLUCION DE PROBLEMAS
# ============================================
function Start-Troubleshoot {
    Banner -Ttl $MSG.ToolsTitle
    Write-Host "  $($MSG.ToolsInstr1)" -ForegroundColor $C.White
    Write-Host "  $($MSG.ToolsInstr2)" -ForegroundColor $C.Cyan
    Write-Host "  $($MSG.ToolsInstr3)" -ForegroundColor $C.White
    Write-Host ""
    try { Invoke-Expression (Invoke-RestMethod https://get.activated.win) } catch { Step "Error: $($_.Exception.Message)" -S "error" }
    Pause-Menu
}

# ============================================
# INFORMACION DEL SISTEMA
# ============================================
function Show-SystemInfo {
    Banner -Ttl $MSG.SysInfoTitle
    $os   = Get-CimInstance Win32_OperatingSystem
    $cpu  = Get-CimInstance Win32_Processor
    $ram  = Get-CimInstance Win32_ComputerSystem
    $disk = Get-PSDrive -Name C

    $offInstalled = $false
    $wordPaths = @(
        "$env:ProgramFiles\Microsoft Office\root\Office16\WINWORD.EXE",
        "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\WINWORD.EXE",
        "$env:ProgramFiles\Microsoft Office\Office16\WINWORD.EXE",
        "${env:ProgramFiles(x86)}\Microsoft Office\Office16\WINWORD.EXE"
    )
    foreach ($wp in $wordPaths) { if (Test-Path $wp) { $offInstalled = $true; break } }

    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.SysInfoWin)" -ForegroundColor $C.Cyan
    Write-Host "  |    $($MSG.SysInfoSO): $($os.Caption)" -ForegroundColor $C.White
    Write-Host "  |    $($MSG.SysInfoBuild): $($os.BuildNumber)" -ForegroundColor $C.White
    Write-Host "  |    $($MSG.SysInfoArch): $($os.OSArchitecture)" -ForegroundColor $C.White
    Write-Host "  |" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.SysInfoHW)" -ForegroundColor $C.Cyan
    Write-Host "  |    $($MSG.SysInfoCPU): $($cpu.Name.Trim())" -ForegroundColor $C.White
    Write-Host "  |    $($MSG.SysInfoRAM): $([math]::Round($ram.TotalPhysicalMemory/1GB,1)) GB" -ForegroundColor $C.White
    Write-Host "  |    $($MSG.SysInfoDisk): $([math]::Round($disk.Free/1GB,1)) $($MSG.SysInfoFree)" -ForegroundColor $C.White
    Write-Host "  |" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.SysInfoOffice)" -ForegroundColor $C.Cyan
    if ($offInstalled) {
        Write-Host "  |    Estado: $($MSG.SysInfoOFFInst)" -ForegroundColor $C.Green
    } else {
        Write-Host "  |    Estado: $($MSG.SysInfoOFFNo)" -ForegroundColor $C.Red
    }
    Write-Host "  |" -ForegroundColor $C.Cyan
    Write-Host "  |  $($MSG.SysInfoNet)" -ForegroundColor $C.Cyan
    if (Test-Internet) {
        Write-Host "  |    Estado: $($MSG.SysInfoNetOK)" -ForegroundColor $C.Green
    } else {
        Write-Host "  |    Estado: $($MSG.SysInfoNetFail)" -ForegroundColor $C.Red
    }
    Write-Host "  +------------------------------------------------------+" -ForegroundColor $C.Cyan
    Write-Host "  $($MSG.BannerBy) | MAS massgrave.dev" -ForegroundColor $C.DarkGray
    Write-Host ""
    Pause-Menu
}

# ============================================
# MENU DE INSTALACION (16 versiones)
# ============================================
function InstallMenu {
    Banner -Ttl $MSG.InstallMenuTitle -Sub $MSG.InstallMenuSub

    $categories = @("Microsoft 365", "Office 2024", "Office 2021", "Office 2019", "Office 2016")

    foreach ($cat in $categories) {
        Write-Host "  --- $cat ---" -ForegroundColor $C.Cyan
        Write-Host ""

        foreach ($v in $Versions) {
            if ($v.Cat -eq $cat) {
                if ($v.Feat) {
                    Write-Host "  [$($v.N)]  [*] $($v.Name)" -ForegroundColor $C.Green
                } else {
                    Write-Host "  [$($v.N)]  $($v.Name)" -ForegroundColor $C.Yellow
                }
                Write-Host "       $($v.Desc)" -ForegroundColor $C.Gray
                Write-Host ""
            }
        }
    }

    Write-Host "  [0]  $($MSG.Back)" -ForegroundColor $C.DarkGray
    Write-Host ""
    Write-Host "  [i]  $($MSG.InstallFooter)" -ForegroundColor $C.Gray
    Write-Host "  [!]  $($MSG.InstallNote)" -ForegroundColor $C.Yellow
    Write-Host ""
    Write-Host "  $($MSG.Choose) (0-16): " -ForegroundColor $C.White -NoNewline
    return Read-Host
}

# ============================================
# MENU PRINCIPAL
# ============================================
function MainMenu {
    Banner -Ttl $MSG.MenuMainTitle -Sub $MSG.MenuMainSub
    Write-Host "  [1]  $($MSG.MenuOpt1)" -ForegroundColor $C.Green
    Write-Host "       $($MSG.MenuOpt1Desc)" -ForegroundColor $C.Gray
    Write-Host ""
    Write-Host "  [2]  $($MSG.MenuOpt2)" -ForegroundColor $C.Green
    Write-Host "       $($MSG.MenuOpt2Desc)" -ForegroundColor $C.Gray
    Write-Host ""
    Write-Host "  [3]  $($MSG.MenuOpt3)" -ForegroundColor $C.Yellow
    Write-Host "       $($MSG.MenuOpt3Desc)" -ForegroundColor $C.Gray
    Write-Host ""
    Write-Host "  [4]  $($MSG.MenuOpt4)" -ForegroundColor $C.Red
    Write-Host "       $($MSG.MenuOpt4Desc)" -ForegroundColor $C.Gray
    Write-Host ""
    Write-Host "  [5]  $($MSG.MenuOpt5)" -ForegroundColor $C.Magenta
    Write-Host "       $($MSG.MenuOpt5Desc)" -ForegroundColor $C.Gray
    Write-Host ""
    Write-Host "  [6]  $($MSG.MenuOpt6)" -ForegroundColor $C.Yellow
    Write-Host "       $($MSG.MenuOpt6Desc)" -ForegroundColor $C.Gray
    Write-Host ""
    Write-Host "  [7]  $($MSG.MenuOpt7)" -ForegroundColor $C.Yellow
    Write-Host "       $($MSG.MenuOpt7Desc)" -ForegroundColor $C.Gray
    Write-Host ""
    Write-Host "  [8]  $($MSG.MenuOpt8)" -ForegroundColor $C.Gray
    Write-Host "       $($MSG.MenuOpt8Desc)" -ForegroundColor $C.Gray
    Write-Host ""
    Write-Host "  [0]  $($MSG.MenuOpt0)" -ForegroundColor $C.DarkGray
    Write-Host ""
    Write-Host "  $($MSG.MenuFooter): " -ForegroundColor $C.White -NoNewline
    return Read-Host
}

# ============================================
# INICIO - VERIFICACION DE ADMIN
# ============================================
Write-Log "=== Office Helper v12 started ==="
Write-Log "User: $env:USERNAME | PC: $env:COMPUTERNAME"

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")

if (-not $isAdmin) {
    Clear-Host
    Banner -Ttl $MSG.BannerTitle
    Write-Host "  [!]  $($MSG.AdminReq)" -ForegroundColor $C.Yellow
    Write-Host "  [i]  $($MSG.AdminInfo)" -ForegroundColor $C.Gray
    Write-Host "  [i]  $($MSG.AdminAccept)" -ForegroundColor $C.Gray
    Write-Host ""
    Write-Host "  $($MSG.PressCont)" -ForegroundColor $C.Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Log "Requesting elevation"
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Lang $Lang"
    exit
}

Write-Log "Admin: YES"

# ============================================
# BUCLE PRINCIPAL
# ============================================
do {
    $choice = MainMenu
    switch ($choice) {
        "1" {
            $ic = InstallMenu
            $found = $false
            foreach ($v in $Versions) {
                if ($ic -eq "$($v.N)") {
                    $found = $true
                    Start-OfficeInstall -ProductID $v.ID -VersionName $v.Name
                    break
                }
            }
            if (-not $found -and $ic -ne "0") {
                Step $MSG.Invalid -S "error"
                Start-Sleep 2
            }
        }
        "2" { Start-OfficeActivation }
        "3" { Start-OfficeRepair }
        "4" { Start-OfficeUninstall }
        "5" { Start-WindowsActivation }
        "6" { Show-CheckStatus }
        "7" { Start-Troubleshoot }
        "8" { Show-SystemInfo }
        "0" {
            Write-Log "User exited"
            Clear-Host
            Banner -Ttl "HASTA LUEGO"
            Write-Host "  Gracias por usar Office Helper" -ForegroundColor $C.White
            Write-Host "  $($MSG.BannerBy)" -ForegroundColor $C.DarkGray
            Write-Host ""
            Start-Sleep 2
            exit
        }
        default {
            Step $MSG.Invalid -S "error"
            Start-Sleep 2
        }
    }
} while ($true)