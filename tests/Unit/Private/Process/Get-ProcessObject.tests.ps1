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

Describe 'Get-ProcessObject' -Tag Private, Unit {
    Context 'When object can be created' {
        BeforeAll {
            Mock -CommandName 'Resolve-DscExe' -MockWith { "$env:LOCALAPPDATA\dsc\dsc.exe" }
        }

        It 'Should return a process object' {
            InModuleScope -ScriptBlock {
                $result = Get-ProcessObject
                $result | Should -BeOfType 'System.Diagnostics.Process'
            }
        }

        It 'Should return a process object with argument' {
            InModuleScope -ScriptBlock {
                $result = Get-ProcessObject -Argument 'resource'
                $result | Should -BeOfType 'System.Diagnostics.Process'
                $result.StartInfo.Arguments | Should -Be 'resource'
            }
        }
    }
}
