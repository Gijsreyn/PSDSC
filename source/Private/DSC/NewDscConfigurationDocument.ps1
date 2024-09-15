function NewDscConfigurationDocument
{
    <#
    .SYNOPSIS
        Create a new configuration document.

    .DESCRIPTION
        The function NewDscConfigurationDocument creates a new configuration document in version 3 format from a PowerShell v1/v2 configuration script.

    .PARAMETER Path
        The path to a PowerShell v1/v2 configuration document script.

    .PARAMETER Format
        The format to return e.g. JSON/YAML.

    .EXAMPLE
        PS C:\> NewDscConfigurationDocument -Path MyConfigurationDocument.ps1

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [ValidateSet('JSON', 'YAML', 'Default')]
        [System.String]
        $Format = 'JSON'
    )

    $configurationDocument = [ordered]@{
        "`$schema" = "https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json"
        resources  = @(ExportDscConfigurationDocument -Path $Path)
    }

    switch ($Format)
    {
        "JSON"
        {
            $inputObject = ($configurationDocument | ConvertTo-Json -Depth 10)
        }
        "YAML"
        {
            if (TestYamlModule)
            {
                $inputObject = ConvertTo-Yaml -InputObject $configurationDocument -Depth 10
            }
            else
            {
                $inputObject = @{}
            }
        }
        default
        {
            $inputObject = $configurationDocument
        }
    }

    return $inputObject
}
