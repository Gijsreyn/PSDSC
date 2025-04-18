Describe 'ConvertTo-DscYaml' {
    Context 'Converts PowerShell script to DSC v3 YAML' {
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

            $script:skip = (Get-Command ConvertFrom-Yaml).Parameters.Keys -contains 'InputObject'
        }

        AfterAll {
            Remove-Item -Path $filePath -Recurse -Force
        }

        It 'Should return valid YAML' -Skip:(!$skip) {
            $yaml = ConvertTo-PsDscYaml -Path $filePath
            $out = $yaml | ConvertFrom-Yaml
            $out.resources.name | Should -Be 'MyConfiguration'
        }
    }
}
