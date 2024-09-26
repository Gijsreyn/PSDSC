Describe 'Initialize-PsDscConfigDocument' {

    # Context block for ResourceName parameter
    Context 'When using ResourceName parameter' {
        It 'should return the correct JSON for Microsoft.Windows/Registry' {
            $result = Initialize-PsDscConfigDocument -ResourceName 'Microsoft.Windows/Registry' -ResourceInput @{'keyPath' = 'HKCU\1' } -ResourceDescription 'Registry'
            $resultCompressed = $result | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress
            $expected = '{"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json","resources":[{"name":"Registry","type":"Microsoft.Windows/Registry","properties":{"keyPath":"HKCU\\1"}}]}'
            $resultCompressed | Should -BeExactly $expected
        }
    }

    # Context block for PowerShell switches
    Context 'When using PowerShell switches' {
        It 'should return the correct JSON for Microsoft.WinGet.DSC/WinGetPackage and IsPwsh' {
            $result = Initialize-PsDscConfigDocument -ResourceName 'Microsoft.WinGet.DSC/WinGetPackage' -IsPwsh -ResourceInput @{ Id = 'Microsoft.PowerShell.Preview' } -ResourceDescription 'WinGetPackage'
            $resultCompressed = $result | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress
            $expected = '{"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json","resources":[{"name":"Using Pwsh","type":"Microsoft.DSC/PowerShell","properties":{"resources":{"name":"WinGetPackage","type":"Microsoft.WinGet.DSC/WinGetPackage","properties":{"Id":"Microsoft.PowerShell.Preview"}}}}]}'
            $resultCompressed | Should -BeExactly $expected
        }

        It 'should return the correct JSON for Microsoft.WinGet.DSC/WinGetPackage and IsWindowsPowerShell' {
            $result = Initialize-PsDscConfigDocument -ResourceName 'Microsoft.WinGet.DSC/WinGetPackage' -ResourceInput @{ Id = 'Microsoft.PowerShell.Preview' } -ResourceDescription 'WinGetPackage' -IsWindowsPowerShell
            $resultCompressed = $result | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress
            $expected = '{"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json","resources":[{"name":"Using Pwsh","type":"Microsoft.Windows/WindowsPowerShell","properties":{"resources":{"name":"WinGetPackage","type":"Microsoft.WinGet.DSC/WinGetPackage","properties":{"Id":"Microsoft.PowerShell.Preview"}}}}]}'
            $resultCompressed | Should -BeExactly $expected
        }
    }
}
