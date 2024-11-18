; NSIS installer script

; Include Modern UI
!include "MUI2.nsh"

; General Installer Configurations
Name "Generative Engineering Setup"
Icon "generative.ico"
InstallDir "$TEMP"

; UI Configuration
!define MUI_ABORTWARNING

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

RequestExecutionLevel user



OutFile "generative-engineering-setup.exe" ; File name of generated installer executable


Section "Install" SEC01

    ; Set output path to installation directory
    SetOutPath "$INSTDIR"

    ; Copy PowerShell script
    File "windows-install.ps1"

    ; Execute PowerShell script with elevated privileges
    DetailPrint "Running installation PowerShell script..."
    nsExec::ExecToLog 'powershell.exe -ExecutionPolicy Bypass -File "$INSTDIR\windows-install.ps1"'

SectionEnd

