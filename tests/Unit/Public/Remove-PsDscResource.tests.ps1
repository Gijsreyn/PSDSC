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

Describe 'Remove-PsDscResource' -Tag 'Public' {
    Context 'When resource and input is valid' {
        BeforeAll {
            Mock -CommandName 'Resolve-DscInput' -MockWith {
                return ((@{test = 'abc' } | ConvertTo-Json -Compress | ConvertTo-Json) -replace "\\\\", "\" | Out-String)
            }
            Mock -CommandName 'Confirm-DscResourceInput' -MockWith {
                return 'resource delete --resource test/Resource --input {\"test\":\"abc\"}'
            }
            Mock -CommandName 'Get-ProcessObject' -MockWith {
                return ([System.Diagnostics.Process]::new())
            }
            Mock -CommandName 'Get-ProcessResult' -MockWith {
                return [PSCustomObject]@{
                    Executable = 'dsc.exe'
                    Arguments  = 'resource delete --resource test/Resource --input {\"test\":\"abc\"}'
                    ExitCode   = 0
                    Output     = '{{"actualState":{"test":"abc"}}}'
                    Error      = $null
                }
            }

        }

        It 'Removes specified PsDsc resource' {
            $result = Remove-PsDscResource -Resource 'test/Resource' -Inputs @{test = 'abc' } -Confirm:$false
            $result | Should -Not -BeNullOrEmpty

            Assert-MockCalled -CommandName 'Resolve-DscInput' -Exactly -Times 1
            Assert-MockCalled -CommandName 'Confirm-DscResourceInput' -Exactly -Times 1
            Assert-MockCalled -CommandName 'Get-ProcessObject' -Exactly -Times 1
            Assert-MockCalled -CommandName 'Get-ProcessResult' -Exactly -Times 1
        }
    }
}
