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

Describe 'Test-IsDscFilePath' -Tag Private, Unit {
    Context 'When path is a valid DSC file path' {
        BeforeAll {
            # Create a JSON file
            $jsonContent = '{"keyPath":"HKCU\\1\\2"}'
            Set-Content -Path "$TestDrive\valid.json" -Value $jsonContent

            # Create a YAML file
            $yamlContent = "keyPath: HKCU\1\2"
            Set-Content -Path "$TestDrive\valid.yaml" -Value $yamlContent
        }

        AfterAll {
            Remove-Item -Path "$TestDrive\valid.json" -Force
            Remove-Item -Path "$TestDrive\valid.yaml" -Force
        }

        It 'Should return true for a valid JSON file path' {
            InModuleScope -ScriptBlock {
                $path = "$TestDrive\valid.json"
                $result = Test-IsDscFilePath -Path $path
                $result | Should -Be $true
            }
        }

        It 'Should return true for a valid YAML file path' {
            InModuleScope -ScriptBlock {
                $path = "$TestDrive\valid.yaml"
                $result = Test-IsDscFilePath -Path $path
                $result | Should -Be $true
            }
        }
    }

    Context 'When path is not a valid DSC file path' {
        BeforeAll {
            # Create a text file
            $textContent = "This is a text file."
            Set-Content -Path "$TestDrive\invalid.txt" -Value $textContent
        }

        AfterAll {
            Remove-Item -Path "$TestDrive\invalid.txt" -Force
        }

        It 'Should return false for a non-DSC file path' {
            InModuleScope -ScriptBlock {
                $path = "$TestDrive\invalid.txt"
                $result = Test-IsDscFilePath -Path $path
                $result | Should -Be $false
            }
        }

        It 'Should return false for a non-existent file path' {
            InModuleScope -ScriptBlock {
                $path = "$TestDrive\nonexistent.json"
                $result = Test-IsDscFilePath -Path $path
                $result | Should -Be $false
            }
        }
    }
}
