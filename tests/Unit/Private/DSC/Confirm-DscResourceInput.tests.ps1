# filepath: /c:/Source/PSDSC/tests/Unit/Private/Confirm-DscResourceInput.tests.ps1
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

Describe 'Confirm-DscResourceInput' -Tag Private {
    Context 'When Inputs is a file path' {
        BeforeAll {
            Mock -CommandName 'Test-Path' -MockWith { $true }
        }

        It 'Should return the correct resource input string with file path' {
            InModuleScope -ScriptBlock {
                $result = Confirm-DscResourceInput -Resource 'Microsoft.Windows/Registry' -Inputs 'input.json' -Operation 'get'
                $result | Should -Be 'resource get --resource Microsoft.Windows/Registry --file input.json'
            }
        }
    }

    Context 'When Inputs is not a file path' -Tag Private {
        BeforeAll {
            Mock -CommandName 'Test-Path' -MockWith { $false }
        }

        It 'Should return the correct resource input string with input data' {
            InModuleScope -ScriptBlock {
                $result = Confirm-DscResourceInput -Resource 'Microsoft.Windows/Registry' -Inputs '{"keyPath":"HKCU\\1\\2"}' -Operation 'get'
                $result | Should -Be 'resource get --resource Microsoft.Windows/Registry --input {"keyPath":"HKCU\\1\\2"}'
            }
        }
    }
}
