BeforeAll {
    $script:moduleName = 'PSDSC'

    Import-Module -Name $script:moduleName

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName
}

AfterAll {
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Get-Module -Name $script:moduleName -All | Remove-Module -Force
}

Describe 'Test-PsDscConfig' -Tag Public, Integration {
    Context "When the input is correct" {
        It 'Should be able to test a resource using a hashtable' {
            $configDoc = @{
                '$schema' = 'https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json'
                resources = @(
                    @{
                        name       = 'Debug Echo'
                        type       = 'Microsoft.DSC.Debug/Echo'
                        properties = @{
                            output = 'hello'
                        }
                    }
                )
            }

            $result = Test-PsDscConfig -Inputs $configDoc
            $output = $result.Output | ConvertFrom-Json
            $result.ExitCode | Should -Be 0
            $output.results.result.inDesiredState | Should -Be $true
        }

        It 'Should be able to test a resource using a JSON string' {
            $configDoc = @'
{
  "$schema": "https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json",
  "resources": [
    {
      "properties": {
        "output": "hello"
      },
      "name": "Debug Echo",
      "type": "Microsoft.DSC.Debug/Echo"
    }
  ]
}
'@
            $result = Test-PsDscConfig -Inputs $configDoc
            $output = $result.Output | ConvertFrom-Json
            $result.ExitCode | Should -Be 0
            $output.results.result.inDesiredState | Should -Be $true
        }

        It 'Should be able to test a resource using a YAML string' {
            $configDoc = @'
$schema: https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json
resources:
- properties:
    output: hello
  name: Debug Echo
  type: Microsoft.DSC.Debug/Echo
'@
            $result = Test-PsDscConfig -Inputs $configDoc
            $output = $result.Output | ConvertFrom-Json
            $result.ExitCode | Should -Be 0
            $output.results.result.inDesiredState | Should -Be $true
        }
    }
}
