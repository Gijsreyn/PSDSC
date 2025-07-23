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

Describe 'Assert-DscVersion' -Tag Private {
    Context 'Assert if a version of DSC is available' {
        It 'Should asserts a correct version of DSC' {
            InModuleScope -ScriptBlock {
                Assert-DscVersion -Version '3.0.0'
            }
        }

        It 'Should throw an error if the version of DSC is not available' {
            InModuleScope -ScriptBlock {
                { Assert-DscVersion -Version '0.0.1' } | Should -Throw
            }
        }
    }
}
