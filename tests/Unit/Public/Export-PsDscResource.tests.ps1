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

Describe 'Export-PsDscResource' -Tag 'Public' {
    Context 'When resource and input is valid' {
        BeforeAll {
            Mock -CommandName 'Get-ProcessObject' -MockWith {
                return ([System.Diagnostics.Process]::new())
            }
            Mock -CommandName 'Get-ProcessResult' -MockWith {
                return [PSCustomObject]@{
                    Executable = 'dsc.exe'
                    Arguments  = 'resource export --resource test/Resource'
                    ExitCode   = 0
                    Output     = '{"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json","contentVersion":"1.0.0","resources":[{"type":"test/Resource","name":"test/Resource-0","properties":{"$id":"https://developer.microsoft.com/json-schemas/dsc/resource/20230303/Microsoft.Dsc.Resource.schema.json"}}]}'
                    Error      = $null
                }
            }

        }

        It 'Exports the specified PsDsc resource' {
            $result = Export-PsDscResource -Resource 'test/Resource'
            $result | Should -Not -BeNullOrEmpty

            Assert-MockCalled -CommandName 'Get-ProcessObject' -Exactly -Times 1
            Assert-MockCalled -CommandName 'Get-ProcessResult' -Exactly -Times 1
        }
    }
}
