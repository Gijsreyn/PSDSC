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

    if (Test-Path "$env:ProgramFiles\dsc" -ErrorAction SilentlyContinue)
    {
        $env:Path += [System.IO.Path]::PathSeparator + "$env:ProgramFiles\dsc"
    }
}

AfterAll {
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force
}

Describe 'Get-CurrentDscExeVersion' -Tag Private, Integration {
    Context 'Check if DSC version is retrieved' {
        It 'Should return a valid version string' {
            InModuleScope -ScriptBlock {
                $result = Get-CurrentDscExeVersion
                $result | Should -Match '3.0.0-*'
            }
        }
    }

    # Context 'Check if DSC is not installed' {
    #     It 'Should return $null' -Skip:(!$IsWindows) {
    #         BeforeDiscovery {
    #             $env:Path = ($env:Path -split ';' | Where-Object { $_ -ne "$env:LOCALAPPDATA\dsc" }) -join ';'
    #         }

    #         InModuleScope -ScriptBlock {
    #             $result = Get-CurrentDscExeVersion
    #             $result | Should -BeNullOrEmpty
    #         }
    #     }

    #     AfterAll {
    #         $env:PATH += [System.IO.Path]::PathSeparator + "$env:LOCALAPPDATA\dsc"
    #     }
    # }
}
