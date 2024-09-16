function ConvertTo-DscYaml
{
    <#
    .SYNOPSIS
        Convert DSC Configuration (v1/v2) Document to YAML.

    .DESCRIPTION
        The function ConvertTo-DscYaml converts a DSC Configuration Document (v1/v2) to YAML.

    .PARAMETER Path
        The file path to a valid DSC Configuration Document.

    .PARAMETER Content
        The content to a valid DSC Configuration Document.

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
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Path')]
        [ValidateScript({
                if (-Not ($_ | Test-Path) )
                {
                    throw "File or folder does not exist"
                }
                if (-Not ($_ | Test-Path -PathType Leaf) )
                {
                    throw "The Path argument must be a file. Folder paths are not allowed."
                }
                return $true
            })]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Content')]
        [System.String]
        $Content
    )

    begin
    {
        Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)
    }

    process
    {
        $configurationDocument = BuildDscConfigDocument @PSBoundParameters
    }

    end
    {
        Write-Verbose ("Ended: {0}" -f $MyInvocation.MyCommand.Name)
        if (TestYamlModule)
        {
            $inputObject = ConvertTo-Yaml -InputObject $configurationDocument -Depth 10
        }
        return $inputObject
    }
}
