Describe 'Initialize-PsDscConfigurationResource' {
    Context 'When ResourceType is found in PowerShell cache' {
        It 'Should set adapterType to Microsoft.DSC/PowerShell' {
            $ResourceType = 'Microsoft.WinGet.DSC/WinGetPackage'
            $result = Initialize-PsDscConfigurationResource -ResourceType $ResourceType -ResourceName 'PowerShell'
            $result.type | Should -Be 'Microsoft.DSC/PowerShell'
        }
    }

    # TODO: Add test for Windows PowerShell
}
