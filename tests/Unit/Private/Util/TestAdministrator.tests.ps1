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

Describe 'TestAdministrator' {
    Context 'Is administrator' {
        It 'Should return true because we are running as administrator' -Skip:(!$env:TF_Build) {
            InModuleScope -ScriptBlock {
                $result = TestAdministrator
                $result | Should -BeTrue
            }
        }
    }
}
