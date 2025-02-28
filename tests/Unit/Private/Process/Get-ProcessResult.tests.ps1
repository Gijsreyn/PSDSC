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

Describe 'Get-ProcessResult' -Tag Private, Unit {
    Context 'When process is provided' {
        It 'Should return process detail' {
            InModuleScope -ScriptBlock {
                $process = [System.Diagnostics.Process]::new()

                $startParameters = @{
                    FileName               = 'powershell'
                    UseShellExecute        = $false
                    RedirectStandardOutput = $true
                    RedirectStandardError  = $true
                    Arguments              = '-NoProfile -Command "Write-Output Hello, World!"'
                }
                $startInfo = [System.Diagnostics.ProcessStartInfo]$startParameters

                $process.StartInfo = $startInfo
                Get-ProcessResult -Process $process | Should -BeOfType 'PSCustomObject'
            }
        }
    }
}
