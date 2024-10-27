function Install-DscCLI
{
    <#
    .SYNOPSIS
        Install DSC CLI (Windows only).

    .DESCRIPTION
        The function Install-DscCLI installs Desired State Configuration version 3 executablle.

    .PARAMETER Force
        This switch will force DSC to be installed, even if another installation is already in place.

    .PARAMETER Version
        The version of DSC to install.

    .PARAMETER UseWinGet
        Use the Windows Package Manager to install DSC.

    .PARAMETER UseGitHub
        Use GitHub to install DSC.

    .EXAMPLE
        PS C:\> Install-DscCli

        Install the latest version of DSC

    .EXAMPLE
        PS C:\> Install-DscCli -Force

        Install DSC and forces the installed if there is already a version installed.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter()]
        [ArgumentCompleter([DscVersionCompleter])]
        [System.String]
        $Version,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$UseWinGet,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$UseGitHub,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )
    Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)

    $base = 'https://api.github.com/repos/PowerShell/DSC/releases'

    if ($PSBoundParameters.ContainsKey('Version'))
    {
        $releaseUrl = ('{0}/tags/v{1}' -f $base, $Version)

        $UseVersion = $true
    }
    else
    {
        # TODO: no latest tag because no official release
        $releaseUrl = $base
    }

    $releases = Invoke-RestMethod -Uri $releaseUrl

    # TODO: remove after latest is known
    if ($releases.Count -gt 1)
    {
        $releases = $releases | Sort-Object -Descending | Select-Object -First 1
    }

    if ($IsWindows)
    {
        if ($UseWinGet.IsPresent)
        {
            $winGetModuleInstalled = TestWinGetModule

            if (-not $winGetModuleInstalled)
            {
                throw "This function requires the 'Microsoft.WinGet.Dsc' module to be installed. Please install it using 'Install-PSResource -Name Microsoft.WinGet.Dsc'."
            }

            $hashArgs = @{
                Id          = '9PCX3HX4HZ0Z'
                MatchOption = 'EqualsCaseInsensitive'
            }

            $versionPackage = Get-WinGetPackage @hashArgs

            if (-not $versionPackage)
            {
                $dscInstalled = Install-WinGetPackage @hashArgs

                if ($dscInstalled.Status -eq 'Ok')
                {
                    $version = GetDscVersion
                    Write-Verbose -Message "DSC successfully installed with version $version"

                    # return
                    return $true
                }
            }

            if ($versionPackage)
            {
                $versions = Find-WinGetPackage @hashArgs | Select-Object -First 1 # TODO: validate if multiple version are available

                if ($versionPackage.Version -le $versions.Version -and $PSBoundParameters.ContainsKey('Force'))
                {
                    Write-Verbose -Message "Updating DSC version: '$($versionPackage.Version)' to '$($versions.Version)'"
                    $dscInstalled = Update-WinGetPackage @hashArgs

                    if ($dscInstalled.Status -eq 'Ok' -or $dscInstalled.Status -eq 'NoApplicableUpgrade')
                    {
                        $version = GetDscVersion
                        Write-Verbose -Message "DSC successfully updated with version $version"

                        # return
                        return $true
                    }
                }

                if ($versionPackage.Version -le $versions.Version)
                {
                    Write-Warning -Message "DSC is already installed with version $($versionPackage.Version), but you have not specified the -Force switch to update it. If you want to update it, please add the -Force parameter."

                    # return
                    return $false
                }
                else
                {
                    Write-Verbose -Message "DSC is already installed with version $($versionPackage.Version)."

                    # return
                    return $true
                }
            }
        }

        if ($UseGitHub.IsPresent)
        {
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
                Join-Path $env:ProgramFiles 'dsc'
            }
            else
            {
                Join-Path $env:LOCALAPPDATA 'dsc'
            }

            Write-Verbose -Message ("Expanding '{0}' to '{1}'" -f $installerPath, $exePath)
            $null = Expand-Archive -LiteralPath $installerPath -DestinationPath $exePath -Force

            if ($elevated)
            {
                $exePath | AddToPath -Persistent:$true
            }
            else
            {
                $exePath | AddToPath -User
            }

            if (TestDsc)
            {
                $dsc = GetDscVersion
                Write-Verbose -Message "DSC successfully installed with version $dsc"

                return $true
            }
        }
    }
    elseif ($IsLinux)
    {
        if ($UseVersion)
        {
            $filePath = '/tmp/DSC-' + $Version + '-x86_64-unknown-linux-gnu.tar.gz'
            $uri = "https://github.com/PowerShell/DSC/releases/download/v$Version/DSC-$Version-x86_64-unknown-linux-gnu.tar.gz"
        }
        else
        {
            $filePath = '/tmp/DSC-3.0.0-x86_64-unknown-linux-gnu.tar.gz'
            $fileName = 'DSC-3.0.0-*-x86_64-unknown-linux-gnu.tar.gz'
            $uri = ($releases.assets | Where-Object -Property Name -Like $fileName).browser_download_url
        }

        Write-Verbose -Message "Using URI: $uri on path: $filePath"
        curl -L -o $filePath $uri
        # Create the target folder where powershell will be placed
        sudo mkdir -p /opt/microsoft/dsc

        # Expand powershell to the target folder
        sudo tar zxf $filePath -C /opt/microsoft/dsc

        # Set execute permissions
        sudo chmod +x /opt/microsoft/dsc

        # Create the symbolic link that points to pwsh
        sudo ln -s /opt/microsoft/dsc /usr/bin/dsc

        # Add to path
        $env:PATH += [System.IO.Path]::PathSeparator + "/usr/bin/dsc"

        return $true
    }
    elseif ($IsMacOS)
    {
        if ($UseVersion)
        {
            $filePath = '/tmp/DSC-' + $Version + '-x86_64-apple-darwin.tar.gz'
            $uri = "https://github.com/PowerShell/DSC/releases/download/v$Version/DSC-$Version-x86_64-apple-darwin.tar.gz"
        }
        else
        {
            $filePath = '/tmp/DSC-3.0.0-x86_64-apple-darwin.tar.gz'
            $fileName = 'DSC-3.0.0-*-x86_64-apple-darwin.tar.gz'
            $uri = ($releases.assets | Where-Object -Property Name -Like $fileName).browser_download_url
        }

        curl -L -o $filePath $uri
        # Create the target folder where powershell will be placed
        sudo mkdir -p /usr/local/microsoft/dsc

        # Expand powershell to the target folder
        sudo tar zxf $filePath -C /usr/local/microsoft/dsc

        # Set execute permissions
        sudo chmod +x /usr/local/microsoft/dsc

        # Create the symbolic link that points to pwsh
        sudo ln -s /usr/local/microsoft/dsc /usr/bin/dsc

        Get-ChildItem -Path /usr/local/microsoft/dsc -Recurse
        # Add to path
        $env:PATH += [System.IO.Path]::PathSeparator + "/usr/local/microsoft/dsc"
    }
}
