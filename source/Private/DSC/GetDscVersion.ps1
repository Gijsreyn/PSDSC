function GetDscVersion
{
    <#
    .SYNOPSIS
        Get DSC version available.

    .DESCRIPTION
        The function GetDscVersion gets the DSC version available locally or on GitHub.

    .PARAMETER UseGitHub
        Switch to search for using GitHub.

    .EXAMPLE
        PS C:\> GetDscVersion -UseGitHub

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UseGitHub
    )

    if ($UseGitHub.IsPresent)
    {
        if ($null -eq $script:availableDscVersions)
        {
            try
            {
                $script:availableDscVersions = GetGithubReleaseVersion -Organization 'PowerShell' -Repository 'DSC' -ErrorAction Stop
            }
            catch
            {
                $script:availableDscVersions = @()
                Write-Verbose -Message "Failed to retrieve all available versions with error: $_"
            }
        }

        return $script:availableDscVersions
    }

    if (TestDsc)
    {
        # TODO: Use Start-Process or GetNetProcessObject
        $version = (dsc --version).Split("-")[-1]
        return $version
    }
    else
    {
        return ""
    }
}
