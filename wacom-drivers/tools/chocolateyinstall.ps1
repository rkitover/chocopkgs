﻿$ErrorActionPreference = 'Stop'
$version  = '6.3.45-1'
$checksum64 = '870c97ddca3af1ccd64604ebf3ca702f5541b13ba85211f6927aee64d0970149'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  url64         = "https://cdn.wacom.com/u/productsupport/drivers/win/professional/WacomTablet_$version.exe"
  softwareName  = 'Wacom Tablet*'
  checksum64    = $checksum64
  checksumType64= 'sha256'
  silentArgs    = '/S'
  validExitCodes= @(0, 1, 2)
  # 0 installed (nothing more, nothing less)
  # 1 installed, but reboot is required now (prior installation no pending reboot)
  # 2 installed, but there was already a pending reboot prior to installation
}

if((Get-OSArchitectureWidth -Compare 32) -or $env:ChocolateyForceX86) {
  Write-Warning 'Wacom has ended support for 32-bit operating systems.'
  Write-Warning '32-bit users should specify version 6.3.40.3'
  Write-Error '32-bit is no longer supported.'
}

Install-ChocolateyPackage @packageArgs

Write-Host 'Wacom recommends rebooting the computer prior to using a tablet.' -ForegroundColor Cyan
