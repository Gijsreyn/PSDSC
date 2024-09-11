function GetGithubReleaseVersion
{
    <#
    .SYNOPSIS
        Get GitHub release version using API.

    .DESCRIPTION
        The function GetGithubReleaseVersion gets a GitHub release using the API.

    .PARAMETER Organization
        The organization name to look for.

    .PARAMETER Repository
        The repository name to look for in the organization.

    .PARAMETER Latest
        Switch to grab latest version if available.

    .EXAMPLE
        PS C:\> GetGitHubReleaseVersion -Organization PowerShell -Repository DSC

        Returns a list of available versions for DSC repository

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $Organization,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Repository,

        [System.Management.Automation.SwitchParameter]
        $Latest
    )
    $Url = 'https://api.github.com/repos/{0}/{1}/releases' -f $Organization, $Repository
    if ($Latest.IsPresent)
    {
        $Url = '{0}/latest' -f $Url
    }
    try
    {
        $Versions = Invoke-RestMethod -Uri $Url -ErrorAction 'Stop'
        # TODO: when versions become version, change to system.version
        return ($versions.tag_name | Foreach-Object -Process { $_.TrimStart("v") -as [System.String] })
    }
    catch
    {
        Write-Error -Message "Could not get version of $Organization/$Repository from GitHub. $_" -Category ObjectNotFound
    }
}
