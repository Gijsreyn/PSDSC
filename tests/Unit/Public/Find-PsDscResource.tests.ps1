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

Describe 'Find-PsDscResource' -Tag 'Public' {
    Context "When resource and input is valid" {
        BeforeAll {
            Mock Get-ProcessObject {
                Mock -CommandName 'Get-ProcessObject' -MockWith {
                    return ([System.Diagnostics.Process]::new())
                }
            }

            Mock -CommandName Get-ProcessResult -MockWith {
                return [PSCustomObject]@{
                    Executable = 'dsc.exe'
                    Arguments  = 'resource list'
                    ExitCode   = 0
                    Output     = '{"type":"Microsoft.DSC.Debug/Echo","kind":"Resource","version":"1.0.0","capabilities":["Get","Set","Test"],"path":"C:\\Program Files\\dsc\\echo.dsc.resource.json","description":null,"directory":"C:\\Program Files\\dsc","implementedAs":null,"author":null,"properties":[],"requireAdapter":null,"manifest":{"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/bundled/resource/manifest.json","type":"Microsoft.DSC.Debug/Echo","version":"1.0.0","description":null,"tags":null,"get":{"executable":"dscecho","args":[{"jsonInputArg":"--input","mandatory":true}]},"set":{"executable":"dscecho","args":[{"jsonInputArg":"--input","mandatory":true}],"input":null},"test":{"executable":"dscecho","args":[{"jsonInputArg":"--input","mandatory":true}],"input":null},"schema":{"command":{"executable":"dscecho","args":null}}}}'
                    Error      = $null
                }
            }
        }

        It 'Should get a list of all PsDsc resources' {
            $result = Find-PsDscResource
            $result | Should -Not -BeNullOrEmpty

            Assert-MockCalled -CommandName 'Get-ProcessObject' -Exactly -Times 1
            Assert-MockCalled -CommandName 'Get-ProcessResult' -Exactly -Times 1
        }

        It 'Should call Get-ProcessObject with correct arguments when AdapterName is provided' {
            $adapterName = 'Microsoft.DSC/PowerShell'
            $expectedArgument = 'resource list --adapter Microsoft.DSC/PowerShell'

            Find-PsDscResource -AdapterName $adapterName

            Assert-MockCalled Get-ProcessObject -Exactly -Scope It -ParameterFilter {
                $Argument -eq $expectedArgument
            }
        }

        It 'Should call Get-ProcessObject with correct arguments when Description is provided' {
            $description = 'TestDescription'
            $expectedArgument = 'resource list --description TestDescription'

            Find-PsDscResource -Description $description

            Assert-MockCalled Get-ProcessObject -Exactly -Scope It -ParameterFilter {
                $Argument -eq $expectedArgument
            }
        }

        It 'Should call Get-ProcessObject with correct arguments when Tag is provided' {
            $tag = 'TestTag'
            $expectedArgument = 'resource list --tag TestTag'

            Find-PsDscResource -Tag $tag

            Assert-MockCalled Get-ProcessObject -Exactly -Scope It -ParameterFilter {
                $Argument -eq $expectedArgument
            }
        }
    }
}
