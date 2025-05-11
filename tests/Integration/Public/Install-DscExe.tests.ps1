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

Describe 'Install-DscExe' -Tag Public, Integration {
    Context 'When the executable is not installed' {
        It 'Should install the executable successfully on Windows' -Skip:(!$IsWindows) {
            Install-DscExe | Should -Be $true
        }

        It 'Should install the executable with -Force on Windows' -Skip:(!$IsWindows) {
            Install-DscExe -Force | Should -Be $true
        }

        It 'Should install the executable with -IncludePrerelease on Windows' -Skip:(!$IsWindows) {
            Install-DscExe -IncludePrerelease | Should -Be $true
        }
    }
}
