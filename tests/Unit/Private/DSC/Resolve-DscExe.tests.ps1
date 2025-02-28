BeforeAll {
    # TODO: Find way how to install / uninstall yayaml or unload from current session
    $script:moduleName = 'PSDSC'

    # If the module is not found, run the build task 'noop'.
    if (-not (Get-Module -Name $script:moduleName -ListAvailable))
    {
        # Redirect all streams to $null, except the error stream (stream 2)
        & "$PSScriptRoot/../../../../build.ps1" -Tasks 'noop' 2>&1 4>&1 5>&1 6>&1 > $null
    }

    # Re-import the module using force to get any code changes between runs.
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

Describe 'Resolve-DscExe' -Tag Private, Unit {
    Context 'Resolve path to dsc' {
        BeforeAll {
            Mock -CommandName 'Resolve-DscExe' -MockWith { Join-Path -Path $env:LOCALAPPDATA -ChildPath 'dsc\dsc.exe' }
        }
        It 'Should return the path of dsc' {
            InModuleScope -ScriptBlock {
                $result = Resolve-DscExe
                $result | Should -Be "$env:LOCALAPPDATA\dsc\dsc.exe"
            }
        }
    }

    Context 'Resolve path to dsc when dsc.exe does not exist' {
        BeforeAll {
            Mock -CommandName 'Resolve-DscExe' -MockWith { return $null }
        }

        It 'Should return null' {
            InModuleScope -ScriptBlock {
                $result = Resolve-DscExe
                $result | Should -BeNullOrEmpty
            }
        }
    }

    Context 'Resolve path to dsc when $script:dscExePath is set' {
        BeforeAll {
            $script:dscExePath = 'C:\CustomPath\dsc.exe'
            Mock -CommandName 'Resolve-DscExe' -MockWith { $script:dscExePath }
        }

        It 'Should return the custom path of dsc' {
            InModuleScope -ScriptBlock {
                $result = Resolve-DscExe
                $result | Should -Be 'C:\CustomPath\dsc.exe'
            }
        }

        AfterAll {
            Remove-Variable -Name 'dscExePath' -Scope Script
        }
    }
}
