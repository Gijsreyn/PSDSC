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

Describe 'ConvertToDscObject' {
    Context 'Converts configuration document into object' {
        It 'Should unable to read files without .ps1 extension' {
            InModuleScope -ScriptBlock {
                $filePath = (Join-Path -Path $TestDrive -ChildPath 'test.ps1')
                New-Item -Path $filePath -ItemType File
                $content = @'
configuration MyConfiguration {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {
        Environment CreatePathEnvironmentVariable
        {
            Name = 'TestPathEnvironmentVariable'
            Value = 'TestValue'
            Ensure = 'Present'
            Path = $true
            # TODO: find out how to use Target = @('Process')
        }
    }
}
'@
                Set-Content -Path $filePath -Value $content
                $res = ConvertToDscObject -Path $filePath
                $res.Count | Should -Be 9
            }
        }
    }
}
