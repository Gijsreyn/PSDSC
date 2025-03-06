function Get-PsDscPowerShellManifestResource
{
    <#
    .SYNOPSIS
        Search for a PowerShell DSC resource manifest in the cache.

    .DESCRIPTION
        The function Get-PsDscPowerShellManifestResource searches for a PowerShell DSC resource manifest in the cache.

    .PARAMETER Resource
        The name of the resource to search for.

    .EXAMPLE
        PS C:\> Get-PsDscPowerShellManifestResource -Resource 'Microsoft.WinGet.DSC/WinGetPackage'

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Resource
    )

    # Check for PowerShell class-based first
    $cacheFilePath = Join-Path $env:LocalAppData "dsc\PSAdapterCache.json"

    if (-not (Test-Path $cacheFilePath -ErrorAction SilentlyContinue))
    {
        Write-Warning -Message "No PowerShell class-based manifest found. Please run 'Find-PsDscResource' to generate the cache."
        return
    }

    $poshManifest = Get-PsDscPowerShellResourceSchema -Resource $Resource -CacheFilePath $cacheFilePath

    if (-not $poshManifest)
    {
        Write-Warning -Message "No PowerShell class-based manifest found for resource '$Resource'."

        # Check for PowerShell script-based
        $cacheFilePath = Join-Path $env:LocalAppData "dsc\WindowsPSAdapterCache.json"

        if (-not (Test-Path $cacheFilePath -ErrorAction SilentlyContinue))
        {
            Write-Warning -Message "No PowerShell script-based manifest found. Please run 'Find-PsDscResource' to generate the cache."
            return
        }

        $poshManifest = Get-PsDscPowerShellResourceSchema -Resource $Resource -CacheFilePath $cacheFilePath

        if (-not $poshManifest)
        {
            Write-Warning -Message "No PowerShell script-based manifest found for resource '$Resource'."
            return
        }
    }

    return $poshManifest
}
