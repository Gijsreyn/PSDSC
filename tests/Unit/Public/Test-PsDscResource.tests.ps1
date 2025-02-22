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

Describe 'Test-PsDscResource' -Tag 'Public' {
    Context 'When resource and input is valid' {
        BeforeAll {
            Mock -CommandName 'Resolve-DscResourceInput' -MockWith {
                return ((@{test = 'abc' } | ConvertTo-Json -Compress | ConvertTo-Json) -replace "\\\\", "\" | Out-String)
            }
            Mock -CommandName 'Confirm-DscResourceInput' -MockWith {
                return 'resource test --resource test/Resource --input {\"test\":\"abc\"}'
            }
            Mock -CommandName 'Get-ProcessObject' -MockWith {
                return ([System.Diagnostics.Process]::new())
            }
            Mock -CommandName 'Get-ProcessResult' -MockWith {
                return [PSCustomObject]@{
                    Executable = 'dsc.exe'
                    Arguments  = 'resource test --resource test/Resource --input {\"test\":\"abc\"}'
                    ExitCode   = 0
                    Output     = '{{"actualState":{"test":"abc"}}}'
                    Error      = $null
                }
            }

        }

        It 'Tests the specified PsDsc resource' {
            $result = Test-PsDscResource -Resource 'test/Resource' -Inputs @{test = 'abc' }
            $result | Should -Not -BeNullOrEmpty

            Assert-MockCalled -CommandName 'Resolve-DscResourceInput' -Exactly -Times 1
            Assert-MockCalled -CommandName 'Confirm-DscResourceInput' -Exactly -Times 1
            Assert-MockCalled -CommandName 'Get-ProcessObject' -Exactly -Times 1
            Assert-MockCalled -CommandName 'Get-ProcessResult' -Exactly -Times 1
        }
    }
}
