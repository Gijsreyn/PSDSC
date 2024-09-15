Describe 'Invoke-PsDscResource' {
    BeforeAll {
        $script:yamlPath = (Join-Path -Path $TestDrive -ChildPath 'registry.example.resource.yaml')
        New-Item -Path $yamlPath -ItemType File
        $content = 'keyPath: HKCU'
        Set-Content -Path $yamlPath -Value $content

        $script:jsonPath = (Join-Path -Path $TestDrive -ChildPath 'registry.example.resource.json')
        New-Item -Path $jsonPath -ItemType File
        $content = '{"keyPath":"HKCU"}'
        Set-Content -Path $jsonPath -Value $content

        $script:expectedState = '{"actualState":{"keyPath":"HKCU"}}'
    }

    AfterAll {
        Remove-Item -Path $yamlPath -Recurse -Force
        Remove-Item -Path $jsonPath -Recurse -Force
    }

    Context 'Runs all GET operations' {
        #region Get
        It 'Should invoke the get operation on dsc using hashtable' -Skip:(!$IsWindows) {
            $resourceInput = @{keyPath = 'HKCU' }
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Get -ResourceInput $resourceInput

            $res.ExitCode | Should -Be 0
            $res.Output | Should -Be $script:expectedState
        }
        It 'Should invoke the get operation on dsc using JSON' -Skip:(!$IsWindows) {
            $resourceInput = '{"keyPath":"HKCU"}'
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Get -ResourceInput $resourceInput

            $res.ExitCode | Should -Be 0
            $res.Output | Should -Be $script:expectedState
        }
        It 'Should invoke the get operation on dsc using YAML path' -Skip:(!$IsWindows) {
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Get -ResourceInput $script:yamlPath

            $res.ExitCode | Should -Be 0
            $res.Output | Should -Be $script:expectedState
        }
        It 'Should invoke the get operation on dsc using JSON path' -Skip:(!$IsWindows) {
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Get -ResourceInput $script:jsonPath

            $res.ExitCode | Should -Be 0
            $res.Output | Should -Be $script:expectedState
        }
        #endRegion Get
    }

    Context 'Runs all SET operations' {
        #region Set
        It 'Should invoke the set operation on dsc using hashtable' -Skip:(!$IsWindows) {
            $resourceInput = @{keyPath = 'HKCU' }
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Set -ResourceInput $resourceInput

            $res.ExitCode | Should -Be 0
            ($res.Output | ConvertFrom-Json).changedProperties | Should -BeNullOrEmpty
        }
        It 'Should invoke the set operation on dsc using JSON' -Skip:(!$IsWindows) {
            $resourceInput = '{"keyPath":"HKCU"}'
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Set -ResourceInput $resourceInput

            $res.ExitCode | Should -Be 0
            ($res.Output | ConvertFrom-Json).changedProperties | Should -BeNullOrEmpty
        }
        It 'Should invoke the set operation on dsc using YAML path' -Skip:(!$IsWindows) {
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Set -ResourceInput $script:yamlPath

            $res.ExitCode | Should -Be 0
            ($res.Output | ConvertFrom-Json).changedProperties | Should -BeNullOrEmpty
        }
        It 'Should invoke the set operation on dsc using JSON path' -Skip:(!$IsWindows) {
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Set -ResourceInput $script:jsonPath

            $res.ExitCode | Should -Be 0
            ($res.Output | ConvertFrom-Json).changedProperties | Should -BeNullOrEmpty
        }
        #endRegion Set
    }

    Context 'Runs all TEST operations' {
        #region Test
        It 'Should invoke the test operation on dsc using hashtable' -Skip:(!$IsWindows) {
            $resourceInput = @{keyPath = 'HKCU' }
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Test -ResourceInput $resourceInput

            $res.ExitCode | Should -Be 0
            ($res.Output | ConvertFrom-Json).inDesiredState | Should -BeTrue
        }
        It 'Should invoke the test operation on dsc using JSON' -Skip:(!$IsWindows) {
            $resourceInput = '{"keyPath":"HKCU"}'
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Test -ResourceInput $resourceInput

            $res.ExitCode | Should -Be 0
            ($res.Output | ConvertFrom-Json).inDesiredState | Should -BeTrue
        }
        It 'Should invoke the test operation on dsc using YAML path' -Skip:(!$IsWindows) {
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Test -ResourceInput $script:yamlPath

            $res.ExitCode | Should -Be 0
            ($res.Output | ConvertFrom-Json).inDesiredState | Should -BeTrue
        }
        It 'Should invoke the test operation on dsc using JSON path' -Skip:(!$IsWindows) {
            $res = Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Test -ResourceInput $script:jsonPath

            $res.ExitCode | Should -Be 0
            ($res.Output | ConvertFrom-Json).inDesiredState | Should -BeTrue
        }
    }
}
