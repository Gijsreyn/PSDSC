BeforeAll {
    # TODO: PSDesiredStateConfiguration module should be present
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

Describe 'GetDscInputArgument' {
    Context 'Get the input from dsc resources' {
        It 'Should return the same resources when listing out' {
            InModuleScope -ScriptBlock {
                # use the process command
                $process = GetNetProcessObject -SubCommand 'resource list'
                $out = StartNetProcessObject -Process $process
                $resources = $out.Output | ConvertFrom-Json

                # get the values
                $inputArguments = GetDscInputArgument
                $inputArguments.Count | Should -BeExactly $resources.count
            }
        }
        It 'Should return example code for argument completer' {
            InModuleScope -ScriptBlock {
                $inputArguments = GetDscInputArgument

                # we know the Microsoft.Windows/Registry has schema
                $resource = $inputArguments | Where-Object type -eq 'Microsoft.Windows/Registry'
                $resource.resourceInput | Should -Not -BeNullOrEmpty
                $resource.resourceInput.Count | Should -BeGreaterThan 1
            }
        }
        It 'Should return warning when manifest cannot be transformed' {
            BeforeAll {
                $exe = ResolveDscExe

                $script:manifestPath = Split-Path -Path $exe

                New-Item -Path $script:manifestPath -Name 'fakeManifest.dsc.resource.json' -Value '@{}' -ItemType File -Force
            }
            AfterAll {
                Remove-Item -Path (Join-Path $script:manifestPath 'fakeManifest.dsc.resource.json') -Force
            }
            InModuleScope -ScriptBlock {
                Mock Write-Warning {}

                # call
                GetDscInputArgument
                Assert-MockCalled Write-Warning -Exactly 1 -Scope It
            }
        }

        # TODO: add embedded schema and adapter test
    }
}
