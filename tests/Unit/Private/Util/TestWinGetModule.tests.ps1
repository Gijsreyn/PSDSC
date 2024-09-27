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
}

AfterAll {
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')

    Remove-Module -Name $script:moduleName
}

Describe "TestWinGetModule" {
    Context "When the module is installed" {
        It "Should return true for an installed module" {
            # Mock Get-Module to simulate an installed module
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-Module -MockWith {
                    return @{ Name = "Microsoft.WinGet.Dsc" }
                }

                $result = TestWinGetModule -ModuleName "Microsoft.WinGet.Dsc"
                $result | Should -Be $true
            }
        }
    }

    Context "When the module is not installed" {
        It "Should return false for a non-installed module" {
            InModuleScope -ScriptBlock {
                # Mock Get-Module to simulate a non-installed module
                Mock -CommandName Get-Module -MockWith {
                    return $null
                }

                $result = TestWinGetModule -ModuleName "NonExistentModule"
                $result | Should -Be $false
            }

        }
    }

    Context "When no module name is specified" {
        It "Should return true for the default module if installed" {
            InModuleScope -ScriptBlock {
                # Mock Get-Module to simulate the default module being installed
                Mock -CommandName Get-Module -MockWith {
                    return @{ Name = "Microsoft.WinGet.Dsc" }
                }

                $result = TestWinGetModule
                $result | Should -Be $true
            }

        }

        # It "Should return false for the default module if not installed" {
        #     # Mock Get-Module to simulate the default module not being installed
        #     InModuleScope -ScriptBlock {
        #         Mock -CommandName Get-Module -MockWith {
        #             return $null
        #         }

        #         $result = TestWinGetModule
        #         $result | Should -Be $false
        #     }
        # }
    }
}
