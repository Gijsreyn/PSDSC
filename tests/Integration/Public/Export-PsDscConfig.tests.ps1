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

Describe 'Export-PsDscConfig' -Tag Public, Integration {
    Context "When the input is correct" {
        It 'Should be able to export a resource using a hashtable' {
            $configDoc = @{
                '$schema' = 'https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json'
                resources = @(
                    @{
                        name       = 'OSInfo'
                        type       = 'Microsoft/OSInfo'
                        properties = @{
                        }
                    }
                )
            }

            $result = Export-PsDscConfig -Inputs $configDoc
            $result.ExitCode | Should -Be 0
            $result.Output | Should -Not -BeNullOrEmpty
        }

        It 'Should be able to export a resource using a JSON string' {
            $configDoc = @'
{
  "$schema": "https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json",
  "resources": [
    {
      "properties": {},
      "name": "OSInfo",
      "type": "Microsoft/OSInfo"
    }
  ]
}
'@
            $result = Export-PsDscConfig -Inputs $configDoc
            $result.ExitCode | Should -Be 0
            $result.Output | Should -Not -BeNullOrEmpty
        }

        It 'Should be able to export a resource using a YAML string' {
            $configDoc = @'
$schema: https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json
resources:
- properties: {}
  name: OSInfo
  type: Microsoft/OSInfo
'@
            $result = Export-PsDscConfig -Inputs $configDoc
            $result.ExitCode | Should -Be 0
            $result.Output | Should -Not -BeNullOrEmpty
        }
    }
}
