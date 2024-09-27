function Install-DscCLI
{
    <#
    .SYNOPSIS
        Install DSC CLI (Windows only).

    .DESCRIPTION
        The function Install-DscCLI installs Desired State Configuration version 3 executablle.

    .PARAMETER Force
        This switch will force DSC to be installed, even if another installation is already in place.

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
        # [Parameter()]
        # TODO: later turn it on if we want to specify versions
        # [ArgumentCompleter([DscVersionCompleter])]
        # [System.String]
        # $Version,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    # TODO: if WinGet package is present, use WinGet for Windows
    Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)

    $winGetModuleInstalled = TestWinGetModule

    if (-not $winGetModuleInstalled)
    {
        throw "This function requires the 'Microsoft.WinGet.Dsc' module to be installed. Please install it using 'Install-PSResource -Name Microsoft.WinGet.Dsc'."
    }

    if ($IsWindows)
    {
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
}
