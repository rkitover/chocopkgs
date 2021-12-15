﻿$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  file          = Join-Path $toolsDir 'scantailor-advanced-2019.8.16-win32.exe'
  file64        = Join-Path $toolsDir 'scantailor-advanced-2019.8.16-win64.exe'
  softwareName  = 'ScanTailor Advanced*'
  silentArgs    = "/S"
  validExitCodes= @(0)
}

$additionalArgs = Get-PackageParameters
$targetDir = $null

if($additionalArgs['InstallationPath']) {
  $targetDir = $additionalArgs['InstallationPath']
  $packageArgs['silentArgs'] += " /D=$targetDir"
}

Install-ChocolateyInstallPackage @packageArgs

# Bug in the installer: creates incorrect quick launch icon
$shortcutPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\ScanTailor Advanced\ScanTailor Advanced.lnk"
if($null -eq $targetDir) {
  $targetDir = "$env:ProgramFiles\ScanTailor Advanced"
}

Remove-Item `
  -Path $shortcutPath `
  -ErrorAction SilentlyContinue `
  -Force

Install-ChocolateyShortcut `
  -ShortcutFilePath $shortcutPath `
  -TargetPath "$targetDir\scantailor.exe"

# Remove unnecessary installers
Remove-Item `
  -Path $packageArgs['file'], $packageArgs['file64'] `
  -ErrorAction SilentlyContinue `
  -Force