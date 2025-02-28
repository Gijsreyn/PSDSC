Describe 'New-PsDscVsCodeSettingsFile' {
    BeforeAll {
        $script:filePath = Join-Path -path $TestDrive -ChildPath 'settings.json'
        Set-Content -Path $filePath -Value '{}' -Encoding utf8

        $script:filePath2 = Join-Path -path $TestDrive -ChildPath 'settings2.json'

        $script:filePath3 = Join-Path -path $TestDrive -ChildPath 'settings3.json'
        Set-Content -Path $filePath3 -Value '@{}' -Encoding utf8

        $script:filePath4 = Join-Path -path $testDrive -ChildPath "customsettingsfile.json"
    }
    AfterAll {
        Remove-Item $filePath -Force -ErrorAction SilentlyContinue
        Remove-Item $filePath2 -Force -ErrorAction SilentlyContinue
        Remove-Item $filePath3 -Force -ErrorAction SilentlyContinue
        Remove-Item $filePath4 -Force -ErrorAction SilentlyContinue
    }
    Context "Create setting file tests" {
        It "Add schema definition to a new settings file with confirm" {
            $res = New-PsDscVsCodeSettingsFile -Path $filePath -Confirm:$false
            $res | Should -not -BeNullOrEmpty
        }

        It "Add schema definition to a new settings file without confirm" {
            $res = New-PsDscVsCodeSettingsFile -Path $filePath2
            $res | Should -not -BeNullOrEmpty
        }

        It 'Updates an existing settings file with new schema definitions' {
            $initialContent = '{"existingSetting": "value"}'
            Set-Content -Path $filePath4 -Value $initialContent
            $result = New-PsDscVsCodeSettingsFile -Path $filePath4 -Confirm:$false
            $json = $result | ConvertFrom-Json
            $json.existingSetting | Should -not -BeNullOrEmpty
            $json.'json.schemas' | Should -not -BeNullOrEmpty
            $json.'yaml.schemas' | Should -not -BeNullOrEmpty
        }

        It "Should throw because it is not valid path" {
            { New-PsDscVsCodeSettingsFile -Path $filePath3 } | Should -Throw
        }
    }
}
