import-module au

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1"   = @{
            "(?i)(^\s*fileFullPath\s*=\s*)(.*)"    = "`${1}Join-Path `$toolsDir '$($Latest.FileName32)'"
            "(?i)(^\s*fileFullPath64\s*=\s*)(.*)"  = "`${1}Join-Path `$toolsDir '$($Latest.FileName64)'"
        }
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(\s+x86:).*"          = "`${1} $($Latest.Url32)"
            "(?i)(\s+x64:).*"          = "`${1} $($Latest.Url64)"
            "(?i)(\s+checksum32:).*"   = "`${1} $($Latest.Checksum32)"
            "(?i)(\s+checksum64:).*"   = "`${1} $($Latest.Checksum64)"
        }
        ".\cnote.nuspec" = @{
            "(?i)(\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/shenwei356/cnote/releases'
    $relative_url  = $download_page.links | Where-Object href -match '/shenwei356/cnote/releases/download/V\d+\.\d+(\.\d+)*/cnote_windows_amd64\.exe\.zip' | Select-Object -First 1 -expand href
    $version = ([regex]::Match($relative_url, 'V(\d+\.\d+(\.\d+)*)')).Groups[1].Value
    @{
        Version      = $version
        Url32        = "https://github.com/shenwei356/cnote/releases/download/V$version/cnote_windows_386.exe.zip"
        Url64        = "https://github.com/shenwei356/cnote/releases/download/V$version/cnote_windows_amd64.exe.zip"
        ReleaseNotes = "https://github.com/shenwei356/cnote/releases/tag/V$version"
    }
}

function global:au_BeforeUpdate {
    Get-RemoteFiles -NoSuffix -Purge
}



Update-Package -ChecksumFor None
