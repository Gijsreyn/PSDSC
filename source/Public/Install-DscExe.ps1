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

    .PARAMETER IncludePrerelease
        This switch will allow latest pre-release version of DSC.

    .PARAMETER Token
        The GitHub token to use for authentication when downloading the DSC executable.
        If not provided, the function will attempt to download without authentication.

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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPositionalParameters", "")]
    param (
        [Parameter()]
        [ArgumentCompleter([VersionCompleter])]
        [System.String]
        $Version,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IncludePrerelease,

        [Parameter()]
        [System.Security.SecureString]
        $Token
    )

    $dscInstalled = Test-DscExe

    $base = 'https://api.github.com/repos/PowerShell/DSC/releases'

    $headers = @{
        Accept = 'application/vnd.github.v3+json'
    }

    if ($PSBoundParameters.ContainsKey('Token'))
    {
        # Convert SecureString to plain text for the authorization header
        $plainTextToken = ConvertFrom-SecureString -SecureString $Token -AsPlainText

        $headers.Authorization = "Bearer $plainTextToken"
    }

    if ($PSBoundParameters.ContainsKey('Version'))
    {
        Assert-DscVersion -Version $Version

        $releaseUrl = ('{0}/tags/v{1}' -f $base, $Version)

        $UseVersion = $true
    }
    else
    {
        if ($IncludePrerelease.IsPresent)
        {
            $availableReleases = Invoke-RestMethod -Uri $base -Method 'Get' -Headers $headers -ErrorAction 'Stop'
            $prereleaseTag = $availableReleases |
                Where-Object -FilterScript { -not $_.draft -and $_.prerelease -eq $true } |
                    Sort-Object -Property 'created_at' -Descending |
                        Select-Object -First 1 -ExpandProperty 'tag_name'

            $releaseUrl = ('{0}/tags/{1}' -f $base, $prereleaseTag)
        }
        else
        {
            # TODO: no latest tag because no official release
            $releaseUrl = ('{0}/latest' -f $base)
        }
    }

    $releases = Invoke-RestMethod -Uri $releaseUrl -Headers $headers

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
        $tmpdir = [System.IO.Path]::GetTempPath()

        if ($UseVersion)
        {
            $filePath = [System.IO.Path]::Combine($tmpdir, "DSC-$Version-x86_64-linux.tar.gz")
            $uri = "https://github.com/PowerShell/DSC/releases/download/v$Version/DSC-$Version-x86_64-linux.tar.gz"
        }
        else
        {
            $fileName = 'DSC-*-x86_64-linux.tar.gz'
            $asset = $releases.assets | Where-Object -Property Name -Like $fileName
            $filePath = [System.IO.Path]::Combine($tmpdir, $asset.name)
            $uri = $asset.browser_download_url
        }

        Write-Verbose -Message "Using URI: $uri on path: $filePath"
        curl -L -o $filePath $uri
        # Create the target folder where downloaded file will be extracted
        sudo mkdir -p /opt/microsoft/dsc

        # Expand downloaded file to the target folder
        sudo tar zxf $filePath -C /opt/microsoft/dsc

        # Set execute permissions on the dsc executable
        sudo chmod +x /opt/microsoft/dsc/dsc

        # Create the symbolic link that points to dsc executable
        sudo mkdir -p /usr/local/bin
        sudo ln -fs /opt/microsoft/dsc/dsc /usr/local/bin/dsc

        return $true
    }
    elseif ($IsMacOS)
    {
        $tmpdir = [System.IO.Path]::GetTempPath()

        if ($UseVersion)
        {
            $filePath = [System.IO.Path]::Combine($tmpDir, "DSC-$Version-x86_64-apple-darwin.tar.gz")
            $uri = "https://github.com/PowerShell/DSC/releases/download/v$Version/DSC-$Version-x86_64-apple-darwin.tar.gz"
        }
        else
        {
            $fileName = 'DSC-*-x86_64-apple-darwin.tar.gz'
            $asset = $releases.assets | Where-Object -Property Name -Like $fileName
            $filePath = [System.IO.Path]::Combine($tmpDir, $asset.name)
            $uri = $asset.browser_download_url
        }

        curl -L -o $filePath $uri
        # Create the target folder where downloaded file will be extracted
        sudo mkdir -p /usr/local/microsoft/dsc

        # Expand downloaded file to the target folder
        sudo tar zxf $filePath -C /usr/local/microsoft/dsc

        # Set execute permissions on the dsc executable
        sudo chmod +x /usr/local/microsoft/dsc/dsc

        # Create the symbolic link that points to dsc executables
        sudo mkdir -p /usr/local/bin
        sudo ln -fs /usr/local/microsoft/dsc/dsc /usr/local/bin/dsc

        return $true
    }
}
