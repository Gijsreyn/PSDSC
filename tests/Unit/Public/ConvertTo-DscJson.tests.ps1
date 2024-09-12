Describe 'ConvertTo-DscJson' {
    Context 'Converts PowerShell script to DSC v3 JSON' {
        BeforeAll {
            $script:filePath = (Join-Path -Path $TestDrive -ChildPath 'test.ps1')
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
            Target = @('Process')
        }
    }
}
'@
            Set-Content -Path $filePath -Value $content
        }

        AfterAll {
            Remove-Item -Path $filePath -Recurse -Force
        }

        It 'Should return valid JSON' {
            $json = ConvertTo-DscJson -Path $filePath
            $out = $json | ConvertFrom-Json -Depth 10
            $out.resources.name | Should -Be 'MyConfiguration'
            $out.resources.type | Should -BeLike '*PowerShell*'
            $out.resources.properties.resources.properties.Name | Should -Not -BeNullOrEmpty
            $out.resources.properties.resources.properties.Value | Should -Not -BeNullOrEmpty
            $out.resources.properties.resources.properties.Ensure | Should -Not -BeNullOrEmpty
            $out.resources.properties.resources.properties.Target | Should -Not -BeNullOrEmpty
            $out.resources.properties.resources.properties.Path | Should -Not -BeNullOrEmpty
        }
    }
}
