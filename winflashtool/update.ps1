import-module au

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1"   = @{
            "(^[$]version\s*=\s*)('.*')"  = "`$1'$($Latest.Version)'"
        }
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(\s+Go to).*"           = "`${1} $($Latest.Url64)"
            "(?i)(\s+checksum64:).*"     = "`${1} $($Latest.Checksum64)"
        }
        ".\winflashtool.nuspec" = @{
            "(?i)(\<dependency id=""winflashtool.portable"" version=""\[).*(""\] /\>)" = "`${1}$($Latest.Version)`${2}"
            "(?i)(\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri 'https://sysprogs.com/winflashtool/download/'
    $relative_url  = $download_page.Links | Where-Object href -match 'WinFLASHTool-' | Select-Object -First 1 -expand href
    $version     = ([regex]::Match($relative_url, '/WinFLASHTool-(\d+\.\d+(\.\d+)*)\.exe')).Groups[1].Value
    @{
        Version      = $version
        Url64        = "https://sysprogs.com/getfile/1087/WinFLASHTool-$version.exe"
    }
}

Update-Package -ChecksumFor None
