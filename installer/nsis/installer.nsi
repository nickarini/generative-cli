; NSIS installer script

; Include Modern UI
!include "MUI2.nsh"
!include "LogicLib.nsh"

; Custom Banner and UI Settings
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "installer_banner.bmp"
!define MUI_HEADERIMAGE_RIGHT
!define MUI_WELCOMEFINISHPAGE_BITMAP "sidebar_image.bmp"

; Color Customization
!define MUI_BGCOLOR "FFFFFF"  ; White background
!define MUI_TEXTCOLOR "000000"  ; Black text

; General Installer Configurations
Name "Generative Engineering"
Icon "generative.ico"
!define PRODUCT_FAVICON "generative.ico"
InstallDir "$TEMP"
RequestExecutionLevel user


; Favicon Configuration
Function .onInit
    ; Set favicon for the installer executable
    File "/oname=$TEMP\${PRODUCT_FAVICON}" "${PRODUCT_FAVICON}"
    System::Call 'User32::LoadImage(i 0, t "$TEMP\${PRODUCT_FAVICON}", i 1, i 16, i 16, i 0x0040) i .s'
    Pop $0
    ${If} $0 != 0
        System::Call 'User32::SendMessageA(i $HWNDPARENT, i 0x0080, i 0, i r0) i .s'
        Pop $0
    ${EndIf}
FunctionEnd

; UI Configuration
!define MUI_ICON "generative.ico"
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE "Generative Engineering Setup Installation"
!define MUI_WELCOMEPAGE_TEXT "This installer will guide you through the installation of Generative Engineering prerequisites.$\r$\n$\r$\nClick Next to continue."


; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

; Branding Text
BrandingText "Generative Engineering"

; Compiler Settings for Visual Style
XPStyle on
ManifestSupportedOS all




OutFile "generative-engineering-setup.exe" ; File name of generated installer executable


Section "Install" SEC01

    ; Set output path to installation directory
    SetOutPath "$INSTDIR"

    ; Copy PowerShell script
    File "windows-install.ps1"
    FILE "generative.ico"

    ; Execute PowerShell script with elevated privileges
    DetailPrint "Running installation PowerShell script..."
    nsExec::ExecToLog 'powershell.exe -ExecutionPolicy Bypass -File "$INSTDIR\windows-install.ps1"'

SectionEnd

