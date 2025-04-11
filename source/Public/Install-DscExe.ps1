function Install-DscExe
{
    <#
    .SYNOPSIS
        Install DSC executable.

    .DESCRIPTION
        The function Install-DscExe installs Desired State Configuration version 3 executable.

    .PARAMETER Force
        This switch will force DSC to be installed, even if another installation is already in place.

    .PARAMETER Version
        The version of DSC to install.

    .EXAMPLE
        PS C:\> Install-DscExe

        Install the latest version of DSC

    .EXAMPLE
        PS C:\> Install-DscExe -Force

        Install DSC and forces the installed if there is already a version installed.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPositionalParameters", "PowerShell 7")]
    param (
        [Parameter()]
        [ArgumentCompleter([VersionCompleter])]
        [System.String]
        $Version,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    $dscInstalled = Test-DscExe

    $base = 'https://api.github.com/repos/PowerShell/DSC/releases'

    if ($PSBoundParameters.ContainsKey('Version'))
    {
        $releaseUrl = ('{0}/tags/v{1}' -f $base, $Version)

        $UseVersion = $true
    }
    else
    {
        # TODO: no latest tag because no official release
        $releaseUrl = ('{0}/latest' -f $base)
    }

    $releases = Invoke-RestMethod -Uri $releaseUrl

    if ($IsWindows)
    {
        if ($Force.IsPresent -or -not $dscInstalled)
        {
            $fileName = 'DSC-*-x86_64-pc-windows-msvc.zip'
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
            $exePath = Join-Path $env:LOCALAPPDATA 'dsc'

            Write-Verbose -Message ("Expanding '{0}' to '{1}'" -f $installerPath, $exePath)
            $null = Expand-Archive -LiteralPath $installerPath -DestinationPath $exePath -Force

            # add to current process path
            $env:PATH += [System.IO.Path]::PathSeparator + $exePath

            # add to user path
            $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")

            if ($currentPath -notlike "*$exePath*")
            {
                Write-Verbose -Message "Adding '$exePath' to user PATH"
                [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$exePath", "User")
            }

            # unblock the files
            Get-ChildItem -Path $exePath -Recurse | Unblock-File

            $dscVersion = Get-CurrentDscExeVersion

            if (-not [string]::IsNullOrEmpty($dscVersion))
            {
                Write-Verbose -Message "DSC successfully installed with version '$dscVersion'"

                Remove-Item $installerPath -ErrorAction SilentlyContinue -Force
                return $true
            }
            else
            {
                Write-Warning -Message "Failed to install DSC"
                return $false
            }
        }
        else
        {
            Write-Warning -Message "DSC is already installed. Use -Force to reinstall."
            return $true
        }
    }
    elseif ($IsLinux)
    {
        if ($UseVersion)
        {
            $filePath = [System.IO.Path]::Combine($env:TEMP, "DSC-$Version-x86_64-linux.tar.gz")
            $uri = "https://github.com/PowerShell/DSC/releases/download/v$Version/DSC-$Version-x86_64-linux.tar.gz"
        }
        else
        {
            $fileName = 'DSC-*-x86_64-linux.tar.gz'
            $asset = $releases.assets | Where-Object -Property Name -Like $fileName
            $filePath = [System.IO.Path]::Combine($env:TEMP, $asset.name)
            $uri = $asset.browser_download_url
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
        $env:PATH += [System.IO.Path]::PathSeparator + (Join-Path 'usr' 'bin' 'dsc')

        return $true
    }
    elseif ($IsMacOS)
    {
        if ($UseVersion)
        {
            $filePath = [System.IO.Path]::Combine($env:TEMP, "DSC-$Version-x86_64-apple-darwin.tar.gz")
            $uri = "https://github.com/PowerShell/DSC/releases/download/v$Version/DSC-$Version-x86_64-apple-darwin.tar.gz"
        }
        else
        {
            $fileName = 'DSC-*-x86_64-apple-darwin.tar.gz'
            $asset = $releases.assets | Where-Object -Property Name -Like $fileName
            $filePath = [System.IO.Path]::Combine($env:TEMP, $asset.name)
            $uri = $asset.browser_download_url
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
        $env:PATH += [System.IO.Path]::PathSeparator + (Join-Path 'usr' 'local' 'microsoft' 'dsc')

        return $true
    }
}
