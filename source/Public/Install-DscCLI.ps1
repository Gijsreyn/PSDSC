function Install-DscCLI
{
    <#
    .SYNOPSIS
        Install DSC CLI (Windows only).

    .DESCRIPTION
        The function Install-DscCLI installs Desired State Configuration version 3 executablle.

    .PARAMETER Version
        The version to be installed.

    .PARAMETER Force
        This switch will force DSC to be installed, even if another installation is already in place.

    .EXAMPLE
        PS C:\> Install-DscCli

        Install the latest version of DSC

    .EXAMPLE
        PS C:\> Install-DscCli -Version '3.0.0-preview.9' -Force

        Install preview.9 version of DSC and forces the installation

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [ArgumentCompleter([DscVersionCompleter])]
        [System.String]
        $Version,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    # TODO: if WinGet package is present, use WinGet for Windows
    Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)

    $dscInstalled = TestDsc

    if (-not $IsWindows)
    {
        throw "This function is only supported for Windows systems."
    }

    $base = 'https://api.github.com/repos/PowerShell/DSC/releases'

    if ($PSBoundParameters.ContainsKey('Version'))
    {
        $releaseUrl = ('{0}/tags/v{1}' -f $base, $Version)
    }
    else
    {
        # TODO: no latest tag because no official release
        $releaseUrl = $base
    }

    if ($Force.IsPresent -and $dscInstalled -eq $true)
    {
        Write-Warning -Message "'dsc.exe' is already installed. You can update it using Update-DscCLI."
    }

    if ($Force.IsPresent -or $dscInstalled -eq $false)
    {
        $releases = Invoke-RestMethod -Uri $releaseUrl

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

        # expand the installer to directory
        $elevated = TestAdministrator
        $exePath = if ($elevated)
        {
            "$env:ProgramFiles\DSC"
        }
        else
        {
            "$env:LOCALAPPDATA\DSC"
        }

        Write-Verbose -Message ("Expanding '{0}' to '{1}'" -f $installerPath, $exePath)
        $null = Expand-Archive -LiteralPath $installerPath -DestinationPath $exePath -Force

        if ($elevated)
        {
            $exePath | AddToPath -Persistent:$true
        }
        else
        {
            # TODO: check when user is assigned to throw a warning when multiple environment variables are present e.g. DSC_RESOURCE_PATH
            $exePath | AddToPath -User
        }

        if (TestDsc)
        {
            $dsc = GetDscVersion
            Write-Verbose -Message "DSC successfully installed with version $dsc"
        }
    }
    else
    {
        # TODO: check if we are always getting latest available releases by comparing
    }
}
