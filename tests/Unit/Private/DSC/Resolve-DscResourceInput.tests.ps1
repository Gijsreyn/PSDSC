BeforeAll {
    $script:moduleName = 'PSDSC'

    if (-not (Get-Module -Name $script:moduleName -ListAvailable))
    {
        & "$PSScriptRoot/../../../../build.ps1" -Tasks 'noop' 2>&1 4>&1 5>&1 6>&1 > $null
    }

    Import-Module -Name $script:moduleName -Force -ErrorAction 'Stop'

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName
}

AfterAll {
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force
}

Describe 'Resolve-DscResourceInput' -Tag Private, Unit {
    Context 'When Inputs is a hashtable' {
        It 'Should resolve the hashtable input to a JSON string' {
            InModuleScope -ScriptBlock {
                $inputs = @{ keyPath = 'HKCU\1\2' }
                $result = Resolve-DscResourceInput -Inputs $inputs
                $result | Should -Be '"{\"keyPath\":\"HKCU\\1\\2\"}"'
            }
        }
    }

    Context 'When inputs is a JSON string' {
        It 'Should resolve the JSON string to a JSON string' {
            InModuleScope -ScriptBlock {
                $inputs = '{"keyPath":"HKCU\\1\\2"}'
                $result = Resolve-DscResourceInput -Inputs $inputs
                $result | Should -Be '"{\"keyPath\":\"HKCU\\1\\2\"}"'
            }
        }
    }

    Context 'When inputs is a YAML string' {
        It 'Should resolve the YAML string to a JSON string' {
            InModuleScope -ScriptBlock {
                $inputs = "keyPath: HKCU\1\2"
                $result = Resolve-DscResourceInput -Inputs $inputs
                $result | Should -Be '"{\"keyPath\":\"HKCU\\1\\2\"}"'
            }
        }
    }

    Context 'When inputs is a file path' {
        BeforeAll {
            # Create a JSON file
            $jsonContent = '{"keyPath":"HKCU\\1\\2"}'
            Set-Content -Path "$TestDrive\input.json" -Value $jsonContent

            # Create a YAML file
            $yamlContent = "keyPath: HKCU\1\2"
            Set-Content -Path "$TestDrive\input.yaml" -Value $yamlContent
        }

        AfterAll {
            Remove-Item -Path "$TestDrive\input.json" -Force
            Remove-Item -Path "$TestDrive\input.yaml" -Force
        }

        It 'Should return the file path if it is a valid JSON file' {
            InModuleScope -ScriptBlock {
                $inputs = "$TestDrive\input.json"
                $result = Resolve-DscResourceInput -Inputs $inputs
                $result | Should -Be $inputs
            }
        }

        It 'Should return the file path if it is a valid YAML file' {
            InModuleScope -ScriptBlock {
                $inputs = "$TestDrive\input.yaml"
                $result = Resolve-DscResourceInput -Inputs $inputs
                $result | Should -Be $inputs
            }
        }
    }

    # TODO: The ConvertFrom-Yaml does not throw error if something is not parsed
    # Context 'When inputs is an invalid input' {
    #     It 'Should throw an error for invalid input' {
    #         InModuleScope -ScriptBlock {
    #             { Resolve-DscResourceInput -Inputs 'invalid input' } | Should -Throw "Failed to convert input to JSON or YAML. Error: *"
    #         }
    #     }
    # }
}
