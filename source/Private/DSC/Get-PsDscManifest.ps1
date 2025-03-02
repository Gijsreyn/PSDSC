function Get-PsDscManifest
{
    <#
    .SYNOPSIS
        Search for the manifest of a DSC resource.

    .DESCRIPTION
        The function Get-PsDscManifest searches for the manifest of a DSC resource. The steps it takes are:

        * Search for the manifest in the DSC executable directory.
        * Search for the manifest in the PowerShell adapters.

    .PARAMETER Resource
        The name of the DSC resource.

    .PARAMETER DscExe
        The path to the DSC version 3 executable 'dsc.exe'.

    .EXAMPLE
        PS C:\> Get-PsDscManifest -Resource 'Microsoft.Windows/Registry'

        This example searches for the manifest of the 'Microsoft.Windows/Registry' DSC resource.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Resource,

        [Parameter(Mandatory = $false)]
        [System.String]
        $DscExe = (Resolve-DscExe)
    )

    process
    {
        $rootPath = Split-Path -Path $DscExe -Parent

        $knownExtensions = @('*.dsc.resource.json', '*.dsc.resource.yml', '*.dsc.resource.yaml')

        $manifestFiles = Get-ChildItem -Path "$rootPath\*" -Include $knownExtensions

        # Get the standard manifest first if it exists
        $manifest = Get-PsDscBuiltinManifestResource -ManifestFile $manifestFiles -Resource $Resource

        if (-not $manifest)
        {
            # Go through the PowerShell adapters
            $manifest = Get-PsDscPowerShellManifestResource -Resource $Resource
        }

        return $manifest
    }

}
