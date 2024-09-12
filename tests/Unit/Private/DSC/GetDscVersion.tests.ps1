BeforeAll {
    # TODO: PSDesiredStateConfiguration module should be present
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

Describe 'GetDscVersion' {
    Context 'Gets the available dsc versions' {
        It 'Should return all dsc version from GitHub' {
            InModuleScope -ScriptBlock {
                $result = GetDscVersion -UseGitHub
                $result.Count | Should -BeGreaterThan 1
            }
        }
        It 'Should return the current version' {
            InModuleScope -ScriptBlock {
                $result = GetDscVersion
                $result.Count | Should -Be 1
                $result | Should -BeLike "preview*" # TODO: when official release, change
            }
        }
    }
}
