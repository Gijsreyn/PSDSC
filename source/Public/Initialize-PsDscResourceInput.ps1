function Initialize-PsDscResourceInput
{
    <#
    .SYNOPSIS
        Initializes a hashtable input for a DSC resource.

    .DESCRIPTION
        The Initialize-PsDscResourceInput function retrieves a DSC resource manifest and converts it into
        a hashtable format that can be used as input for DSC operations. It provides an easy way to get
        a template with all properties or just the required ones.

    .PARAMETER Resource
        The name of the DSC resource.

    .PARAMETER RequiredOnly
        When specified, only the required properties are included in the output.

    .EXAMPLE
        PS C:\> Initialize-PsDscResourceInput -Resource 'Microsoft.Windows/Registry'

        Returns a hashtable with all properties for the Registry resource.

    .EXAMPLE
        PS C:\> Initialize-PsDscResourceInput -Resource 'Microsoft.Windows/Registry' -RequiredOnly

        Returns a hashtable with only the required properties for the Registry resource.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Alias('ResourceName')]
        [ArgumentCompleter([ResourceCompleter])]
        [System.String]
        $Resource,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RequiredOnly
    )

    $manifest = Get-PsDscManifest -Resource $Resource

    $resourceInput = ConvertTo-PsDscInput -Manifest $manifest -RequiredOnly:$RequiredOnly

    return $resourceInput
}
