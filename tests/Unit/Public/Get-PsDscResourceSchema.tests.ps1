Describe 'Get-PsDscResourceSchema' {
    Context 'When ResourceName is valid' {
        It 'Retrieves the schema for the specified DSC resource' {
            $result = Get-PsDscResourceSchema -ResourceName 'Microsoft.Windows/Registry'
            $result | Should -Not -BeNullOrEmpty
        }

        It 'Includes properties when IncludeProperty is specified' {
            $result = Get-PsDscResourceSchema -ResourceName 'Microsoft.Windows/Registry' -IncludeProperty
            $result | Should -Not -BeNullOrEmpty
            $result.Contains('keyPath') | Should -BeTrue
        }
    }

    Context 'When ResourceName is invalid' {
        It 'Throws an error' {
            $result = Get-PsDscResourceSchema -ResourceName 'Invalid.Resource'
            $result.Error | Should -not -BeNullOrEmpty
        }
    }
}
