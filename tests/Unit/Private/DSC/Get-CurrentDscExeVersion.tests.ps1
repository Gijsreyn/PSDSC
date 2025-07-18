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

Describe 'Get-CurrentDscExeVersion' -Tag Private, Unit {
    Context 'Check if DSC version is retrieved' {
        Mock -CommandName 'Get-CurrentDscExeVersion' -MockWith { return '3.*.*' }
        It 'Should return a valid version string' {
            InModuleScope -ScriptBlock {
                $result = Get-CurrentDscExeVersion
                $result | Should -Match '3.*.*'
            }
        }
    }
}
