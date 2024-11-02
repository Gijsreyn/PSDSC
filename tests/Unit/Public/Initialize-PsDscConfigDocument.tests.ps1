Describe 'Initialize-PsDscConfigDocument' {

    # Context block for ResourceName parameter
    Context 'When using ResourceName parameter' {
        It 'should return the correct JSON for Microsoft.Windows/Registry' {
            $resource = Init-PsDscConfigResource -ResourceName 'Registry keys' -ResourceType 'Microsoft.Windows/Registry' -ResourceInput @{'keyPath' = 'HKCU\1' }
            $result = (Initialize-PsDscConfigDocument -SchemaVersion '2024/04' -Resource $resource -AsJson | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress)
            $expected = '{"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json","resources":[{"name":"Registry keys","type":"Microsoft.Windows/Registry","properties":{"keyPath":"HKCU\\1"}}]}'
            $result | Should -BeExactly $expected
        }
    }

    # Context block for PowerShell switches
    Context 'When using PowerShell switches' {
        It 'should return the correct JSON for Microsoft.WinGet.DSC/WinGetPackage and IsPwsh' {
            $resource = Init-PsDscConfigResource -ResourceName 'WinGetPackage' -ResourceType 'Microsoft.WinGet.DSC/WinGetPackage' -ResourceInput @{'Id' = 'Microsoft.PowerShell.Preview' }
            $result = (Initialize-PsDscConfigDocument -SchemaVersion '2024/04' -Resource $resource -AsJson | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress)
            $expected = '{"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json","resources":[{"name":"Adapter resource","type":"Microsoft.DSC/PowerShell","properties":{"resources":{"name":"WinGetPackage","type":"Microsoft.WinGet.DSC/WinGetPackage","properties":{"Id":"Microsoft.PowerShell.Preview"}}}}]}'
            $result | Should -BeExactly $expected
        }
    }
}
