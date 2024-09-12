function ConvertTo-DscYaml
{
    <#
    .SYNOPSIS
        Convert DSC Configuration (v1/v2) Document to YAML.

    .DESCRIPTION
        The function ConvertTo-DscYaml converts a DSC Configuration Document (v1/v2) to YAML.

    .PARAMETER Path
        The file path to a valid DSC Configuration Document.

    .EXAMPLE
        PS C:\> $path = 'myConfig.ps1'
        PS C:\> ConvertTo-DscYaml -Path $path

    .INPUTS
        Input a valid DSC Configuration Document

        configuration MyConfiguration {
            Import-DscResource -ModuleName PSDesiredStateConfiguration
            Node localhost
            {
                Environment CreatePathEnvironmentVariable
                {
                    Name = 'TestPathEnvironmentVariable'
                    Value = 'TestValue'
                    Ensure = 'Present'
                    Path = $true
                    Target = @('Process')
                }
            }
        }

    .OUTPUTS
        Returns a YAML string
        $schema: https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json
        resources:
            name: MyConfiguration
            type: Microsoft.DSC/PowerShell
            properties:
                resources:
                - name: CreatePathEnvironmentVariable
                type: PSDscResources/Environment
                properties:
                    Value: TestValue
                    Path: true
                    Name: TestPathEnvironmentVariable
                    Ensure: Present
                    Target:
                    - Process
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline = $true)]
        [System.String]
        $Path
    )

    begin
    {
        Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)
    }

    process
    {
        $inputObject = NewDscConfigurationDocument -Path $Path -Format Yaml
    }

    end
    {
        Write-Verbose ("Ended: {0}" -f $MyInvocation.MyCommand.Name)
        return $inputObject
    }
}
