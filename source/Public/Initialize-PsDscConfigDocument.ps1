function Initialize-PsDscConfigDocument
{
    <#
    .SYNOPSIS
        Initializes a PowerShell DSC Configuration Document.

    .DESCRIPTION
    The Initialize-PsDscConfigDocument function initializes a PowerShell Desired State Configuration (DSC) Configuration Document based on the specified schema version and resources.
    The output can be in JSON or YAML format.

    .PARAMETER SchemaVersion
        Specifies the schema version to use for the configuration document. Valid values are '2024/04' and '2023/10'.

    .PARAMETER Resource
        Specifies the configuration resources to include in the configuration document. This parameter is mandatory.

    .PARAMETER AsJson
        Specifies that the output should be in JSON format. This parameter is optional.

    .PARAMETER AsYaml
        Specifies that the output should be in YAML format. This parameter is optional.

    .EXAMPLE
        PS C:\> $resources = @(
            Initialize-PsDscConfigurationResource -ResourceName 'Registry keys' -ResourceType 'Microsoft.Windows/Registry' -ResourceInput @{'keyPath' = 'HKCU\1'}
        )
        PS C:\> Initialize-PsDscConfigDocument -SchemaVersion '2024/04' -Resource $resources

        This command initializes a DSC Configuration Document using the schema version '2024/04' and the specified resources. The output returns a [ConfigurationDocument] object.

    .EXAMPLE
        PS C:\> $resource = Init-PsDscConfigResource -ResourceName 'WinGetPackage' -ResourceType Microsoft.WinGet.DSC/WinGetPackage -ResourceInput @{'Id' = 'Microsoft.PowerShell.Preview'}
        PS C:\> Initialize-PsDscConfigDocument -SchemaVersion '2023/10' -Resource $resource -AsJson

        This command initializes a DSC Configuration Document using the schema version '2023/10' and the specified resources, and outputs the document in JSON format.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [Alias('Init-PsDscConfigDoc')]
    [OutputType([ConfigurationDocument])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('2024/04', '2023/10')]
        [string]
        $SchemaVersion,

        [Parameter(Mandatory = $true)]
        [ConfigurationResource[]]
        $Resource,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $AsJson,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $AsYaml
    )

    $uri = ("https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/{0}/config/document.json" -f $SchemaVersion)

    $configurationDocument = [ConfigurationDocument]::new($uri, $Resource)

    if ($PSBoundParameters.ContainsKey('Metadata'))
    {
        $configurationDocument.metadata = $Metadata
    }

    if ($AsJson.IsPresent)
    {
        return $configurationDocument.SerializeToJson()
    }

    if ($AsYaml.IsPresent)
    {
        return $configurationDocument.SerializeToYaml()
    }

    return $configurationDocument
}
