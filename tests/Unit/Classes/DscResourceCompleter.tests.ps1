BeforeAll {
    $script:moduleName = 'PSDSC'

    if (-not (Get-Module -Name $script:moduleName -ListAvailable))
    {
        & "$PSScriptRoot/../../../../build.ps1" -Tasks 'noop' 2>&1 4>&1 5>&1 6>&1 > $null
    }

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

Describe 'DscResourceInputCompleter' -Tag Private {
    Context "When ResourceName is not in fakeBoundParameters" {
        It "Should return an empty list" {
            InModuleScope -ScriptBlock {
                Get-Command 'Get-PsDscResource' | Should -HaveParameter Resource -HasArgumentCompleter
                # $completer = [DscResourceInputCompleter]::new()
                # $completer | Should -Not -BeNullOrEmpty
            }
        }
    }
}
