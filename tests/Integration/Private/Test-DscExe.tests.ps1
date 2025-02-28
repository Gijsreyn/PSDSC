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

Describe 'Test-DscExe' -Tag Private, Integration {
    Context 'Check if dsc is installed' {
        It 'Should return true' {
            InModuleScope -ScriptBlock {
                $result = Test-DscExe
                $result | Should -Be $true
            }
        }
    }

    # Context 'Check if dsc is not installed' {
    #     It 'Should return false' -Skip:(!$IsWindows) {
    #         BeforeDiscovery {
    #             $script:commonPaths = @("$env:ProgramFiles\dsc", "$env:localappdata\dsc")
    #         }

    #         InModuleScope -ScriptBlock {
    #             $result = Test-DscExe
    #             $result | Should -Be $false
    #         }
    #     }

    #     AfterAll {
    #         $commonPaths | ForEach-Object {
    #             if (Test-Path $_ -ErrorAction SilentlyContinue)
    #             {
    #                 $env:Path += [System.IO.Path]::PathSeparator + $_
    #             }
    #         }
    #     }
    # }
}
