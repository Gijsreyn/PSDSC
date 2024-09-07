function Get-GithubReleaseVersion
{
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
