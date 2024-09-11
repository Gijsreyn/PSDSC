function ExportDscConfigurationDocument
{
    <#
    .SYNOPSIS
        Export resource(s) into DSC version 3 configuration document.

    .DESCRIPTION
        The function ExportDscConfigurationDocument exports resources into a DSC version 3 configuration document from v1/v2 configuration documents.

    .PARAMETER Path
        The path to a PowerShell v1/v2 configuration document script.

    .EXAMPLE
        PS C:\> ExportDscConfigurationDocument -Path MyConfigurationDocument.ps1

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path
    )

    if (-not (TestPsPathExtension $Path))
    {
        return @{}
    }

    # parse the abstract syntax tree to get all hash table values representing the configuration resources
    [System.Management.Automation.Language.Token[]] $tokens = $null
    [System.Management.Automation.Language.ParseError[]] $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$errors)
    $configurations = $ast.FindAll({ $args[0].GetType().Name -like 'HashtableAst' }, $true)

    # create configuration document resource class (can be re-used)
    $configurationDocument = [PSCustomObject]@{
        name       = $null
        type       = $null
        properties = @{}
    }

    # build simple regex
    $regex = [regex]::new('(?<=configuration\s+)\w+')
    $configValue = $regex.Matches($ast.Extent.Text).Value

    if (-not $configValue)
    {
        return
    }

    $documentConfigurationName = $configValue.TrimStart('Configuration').Trim(" ")

    # start to build the outer basic format
    $configurationDocument.name = $documentConfigurationName
    # hardcoded PowerShell 7 adapter type info
    $configurationDocument.type = 'Microsoft.DSC/PowerShell'

    # bag to hold resources
    $resourceProps = [System.Collections.Generic.List[object]]::new()

    foreach ($configuration in $configurations)
    {
        # get parent configuration details
        $resourceName = ($configuration.Parent.CommandElements.Value | Select-Object -Last 1 )
        $resourceConfigurationName = ($configuration.Parent.CommandElements.Value | Select-Object -First 1)

        # get module details
        $module = Get-DscResource -Name $resourceConfigurationName -ErrorAction SilentlyContinue

        # build the module
        $resource = [PSCustomObject]@{
            name       = $resourceName
            type       = ("{0}/{1}" -f $module.ModuleName, $resourceConfigurationName)
            properties = $configuration.SafeGetValue()
        }

        Write-Verbose ("Adding document with data")
        Write-Verbose ($resource | ConvertTo-Json | Out-String)
        $resourceProps.Add($resource)
    }

    # add all the resources
    $configurationDocument.properties = @{
        resources = $resourceProps
    }

    return $configurationDocument
}
