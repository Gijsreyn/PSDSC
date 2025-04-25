Describe 'ConvertTo-PsDscJson' {
    Context 'Converts PowerShell script to DSC v3 JSON' {
        BeforeAll {
            $script:filePath = (Join-Path -Path $TestDrive -ChildPath 'test.ps1')
            New-Item -Path $filePath -ItemType File
            $script:content = @'
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
        }

        AfterAll {
            Remove-Item -Path $filePath -Recurse -Force
        }

        # TODO: somehow the convertto-json behaves different on Linux/MacOS
        It 'Should return valid JSON using file path' -Skip:(!$IsWindows) {
            $json = ConvertTo-PsDscJson -Path $filePath
            $out = $json | ConvertFrom-Json -Depth 10
            $out.resources.name | Should -Be 'CreatePathEnvironmentVariable'
            $out.resources.type | Should -Be 'PSDesiredStateConfiguration/Environment'
            $out.resources.properties.Value | Should -Be 'TestValue'
            $out.resources.properties.Name | Should -Be 'TestPathEnvironmentVariable'
            $out.resources.properties.Ensure | Should -Be 'Present'
            $out.resources.properties.Path | Should -BeTrue
        }

        It 'Should return valid JSON using content' -Skip:(!$IsWindows) {
            $json = ConvertTo-PsDscJson -Content $content
            $out = $json | ConvertFrom-Json -Depth 10
            $out.resources.name | Should -Be 'CreatePathEnvironmentVariable'
            $out.resources.type | Should -Be 'PSDesiredStateConfiguration/Environment'
            $out.resources.properties.Value | Should -Be 'TestValue'
            $out.resources.properties.Name | Should -Be 'TestPathEnvironmentVariable'
            $out.resources.properties.Ensure | Should -Be 'Present'
            $out.resources.properties.Path | Should -BeTrue
        }
    }
}
