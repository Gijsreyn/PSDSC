param
(
)

task PSDSC.Install {
    Write-Build Yellow "Installing 'dsc.exe' from Github"

    if (-not $IsWindows)
    {
        throw "This function is only supported for Windows systems."
    }

    $base = 'https://api.github.com/repos/PowerShell/DSC/releases'


    $releases = Invoke-RestMethod -Uri $base

    # TODO: remove after latest is known
    if ($releases.Count -gt 1)
    {
        $releases = $releases | Sort-Object -Descending | Select-Object -First 1
    }

    $fileName = 'DSC-3.0.0-*-x86_64-pc-windows-msvc.zip'
    # get latest asset to be downloaded
    $asset = $releases.assets | Where-Object -Property Name -Like $fileName

    # download the installer
    $tmpdir = [System.IO.Path]::GetTempPath()
    $fileName = $asset.name
    $installerPath = [System.IO.Path]::Combine($tmpDir, $fileName)
        (New-Object Net.WebClient).DownloadFileAsync($asset.browser_download_url, $installerPath)
    Write-Verbose "Downloading $($asset.browser_download_url) to location $installerPath"
    do
    {
        $PercentComplete = [math]::Round((Get-Item $installerPath).Length / $asset.size * 100)
        Write-Progress -Activity 'Downloading DSC' -PercentComplete $PercentComplete
        start-sleep 1
    } while ((Get-Item $installerPath).Length -lt $asset.size)

    $installerPath = Join-path $env:ProgramFiles 'dsc'

    Write-Verbose -Message ("Expanding '{0}' to '{1}'" -f $installerPath, $exePath)
    $null = Expand-Archive -LiteralPath $installerPath -DestinationPath $exePath -Force
}
