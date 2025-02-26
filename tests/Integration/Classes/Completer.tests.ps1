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


Describe 'ResourceCompleter' -Tag Private {
    Context "It should return a list of resources when '-Resource' is specified" {
        It "Should return a list" {
            $list = Complete 'Get-PsDscResource -Resource Microsoft'
            $list | Should -Not -BeNullOrEmpty
            $list.ResultType[0] | Should -Be 'ParameterValue'
        }
    }
}

# Describe 'ResourceInputCompleter' -Tag Private {
#     Context "It should return a list of resources when '-Resource' is specified" {
#         It "Should return an empty list" {
#             Complete 'Get-PsDscResource -Resource Microsoft'  | Should -Not -BeNullOrEmpty
#         }
#     }
# }

Describe 'VersionCompleter' -Tag Private {
    Context "It should return a list of versions when '-Version' is specified" {
        It "Should return a list of version " {
            $list = Complete 'Install-DscExe -Version 3.0.0'
            $list | Should -Not -BeNullOrEmpty
            $list.ResultType[0] | Should -Be 'ParameterValue'
        }
    }
}
