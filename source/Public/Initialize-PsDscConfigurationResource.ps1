function Initialize-PsDscConfigurationResource
{
    <#
    .SYNOPSIS
        Initializes a DSC Configuration Resource.

    .DESCRIPTION
        The Initialize-PsDscConfigurationResource function initializes a Desired State Configuration (DSC) resource with the specified name, type, and optional input parameters. It creates an instance of the ConfigurationResource class and sets its properties based on the provided parameters.

    .PARAMETER ResourceName
        Specifies the name of the DSC resource. This parameter is mandatory.

    .PARAMETER ResourceType
        Specifies the type of the DSC resource. This parameter is mandatory and supports argument completer for DSC configuration.

    .PARAMETER ResourceInput
        Specifies the input parameters for the DSC resource. This parameter is optional and allows null values.

    .EXAMPLE
        PS C:\> Initialize-PsDscConfigurationResource -ResourceName 'Registry keys' -ResourceType 'Microsoft.Windows/Registry' -ResourceInput @{'keyPath' = 'HKCU\1'}

        Returns:
        name          type                       properties
        ----          ----                       ----------
        Registry keys Microsoft.Windows/Registry {[type, Microsoft.Windows/Registry]

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [Alias('Init-PsDscConfigResource')]
    [OutputType([ConfigurationResource])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $true)]
        [ArgumentCompleter([DscConfigCompleter])]
        [System.String]
        $ResourceType,

        [Parameter(Mandatory = $false)]
        [ArgumentCompleter([DscConfigInputCompleter])]
        [AllowNull()]
        [object]
        $ResourceInput
    )

    $inputObject = [ConfigurationResource]::new($ResourceName, $ResourceType)

    $resourceTypes = GetDscResourceDetail -Exclude @{kind = 'Adapter' }

    if ($ResourceType -notin $resourceTypes)
    {
        Write-Verbose -Message "Resource type '$ResourceType' is an 'adapter' resource type."
        # check PowerShell adapter cache
        $pwshCache = ReadDscPsAdapterSchema -IsPwsh
        if ($pwshCache)
        {
            if ($pwshCache.Type -contains $ResourceType)
            {
                $adapterType = 'Microsoft.DSC/PowerShell'
            }
        }
        else
        {
            $winPwshCache = ReadDscPsAdapterSchema -IsPwsh:$false
            if ($winPwshCache)
            {
                if ($winPwshCache.Type -contains $ResourceType)
                {
                    $adapterType = 'Microsoft.Windows/WindowsPowerShell'
                }
            }
        }

        if (-not $adapterType)
        {
            Write-Warning -Message "Resource type '$ResourceType' cannot be found. Setting type to '$ResourceType'."
            $adapterType = $ResourceType
        }

        Write-Verbose $adapterType

        return [ConfigurationResource]@{
            name       = 'Adapter resource'
            type       = $adapterType
            properties = [ordered]@{
                resources = [ordered]@{
                    name       = $ResourceName
                    type       = $resourceType
                    properties = $ResourceInput
                }
            }
        }
    }

    if ($PSBoundParameters.ContainsKey('ResourceInput'))
    {
        $inputObject = [ConfigurationResource]::new($ResourceName, $ResourceType, $ResourceInput)
    }

    return $inputObject
}
