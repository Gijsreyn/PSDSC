function Get-DscVersion
{
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
                $script:availableDscVersions = Get-GithubReleaseVersion -Organization 'PowerShell' -Repository 'DSC' -ErrorAction Stop
            }
            catch
            {
                $script:availableDscVersions = @()
                Write-Verbose -Message "Failed to retrieve all available versions with error: $_"
            }
        }

        return $script:availableDscVersions
    }

    if (Test-Dsc)
    {
        $version = (dsc --version).Split("-")[-1]
        return $version
    }
    else
    {
        return ""
    }
}
