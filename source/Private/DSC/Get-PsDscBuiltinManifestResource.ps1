function Get-PsDscBuiltinManifestResource
{
    <#
    .SYNOPSIS
        Get the builtin manifest for a resource from the specified manifest file.

    .DESCRIPTION
        The function Get-PsDscBuiltinManifestResource gets the builtin manifest for a resource from the specified manifest file.

    .PARAMETER ManifestFile
        The manifest file to read. This should be a valid manifest file starting with *.dsc.resource.json, *.dsc.resource.yml, or *.dsc.resource.yaml.

    .PARAMETER Resource
        The resource to get the builtin manifest for e.g. 'Microsoft.Windows/Registry'.

    .EXAMPLE
        PS C:\> Get-PsDscBuiltinManifestResource -ManifestFile 'C:\Program Files\dsc\registry.dsc.resource.json' -Resource 'Microsoft.Windows/Registry'

        This example gets the builtin manifest for the 'Microsoft.Windows/Registry' resource from the specified manifest file.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param
    (
        [Parameter()]
        [System.String[]]
        $ManifestFile,

        [Parameter()]
        [System.String]
        $Resource
    )

    $resourceManifest = foreach ($manifest in $ManifestFile)
    {
        Write-Debug -Message "Reading manifest file: $($manifest.Name)"
        $manifest = Get-Content -Path $manifest | ConvertFrom-Json

        if ($manifest.psobject.properties.name -notcontains 'kind' -and $manifest.type -eq $Resource)
        {
            $manifest
            break
        }
    }

    if (-not $resourceManifest)
    {
        Write-Warning -Message "No builtin manifest found for resource '$Resource'."
    }

    return $resourceManifest
}
