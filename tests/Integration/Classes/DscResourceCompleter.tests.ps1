BeforeAll {
    $script:moduleName = 'PSDSC'

    if (-not (Get-Module -Name $script:moduleName -ListAvailable))
    {
        & "$PSScriptRoot/../../../../build.ps1" -Tasks 'noop' 2>&1 4>&1 5>&1 6>&1 > $null
    }

    Import-Module -Name $script:moduleName -Force -ErrorAction 'Stop'

    $helperModule = Join-Path $PSScriptRoot -ChildPath '../../testHelper.psm1'
    Import-Module -Name $helperModule -Force -ErrorAction 'Stop'

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


Describe 'DscResourceInputCompleter' -Tag Private {
    # Expect dsc to be available to get argument completions
    $valid = [bool](Get-Command 'dsc' -ErrorAction SilentlyContinue)

    Context "When ResourceName is not in fakeBoundParameters" {
        It "Should return an empty list" -Skip:(!$valid) {
            Complete 'Get-PsDscResource -Resource Microsoft'  | Should -Not -BeNullOrEmpty
        }
    }
}
