
BeforeAll {
    # TODO: PSDesiredStateConfiguration module should be present
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

Describe 'ReadDscPsAdapterSchema' {
    Context 'When cache file does not exist' {
        It 'Should return nothing' -Skip:(!$IsWindows) {
            InModuleScope -ScriptBlock {
                $cacheFilePath = Join-Path $env:LocalAppData "dsc" "PSAdapterCache.json"
                if ((Test-Path $cacheFilePath) -and (Get-Item $cacheFilePath -ErrorAction SilentlyContinue).Length -gt 0)
                {
                    Set-Content -Path $cacheFilePath -Value '{}'
                }

                $result = ReadDscPsAdapterSchema
                $result | Should -BeNullOrEmpty
            }
        }
    }
    # TODO: somehow on the ADO agent it does not work
    # Context 'When cache file exists' {
    #     It 'Should return type names when ReturnTypeInfo is specified' -Skip:(!$IsWindows) {
    #         InModuleScope -ScriptBlock {
    #             $cacheFilePath = Join-Path $env:LocalAppData "dsc" "PSAdapterCache.json"
    #             $content = @{
    #                 ResourceCache = @{
    #                     Type            = 'Test/TestResource'
    #                     DscResourceInfo = @{
    #                         ImplementationDetail = 1
    #                         FriendlyName         = 'TestResource'
    #                         Name                 = 'TestResource'
    #                         Module               = 'TestModule.psm1'
    #                         Version              = '1.0.0'
    #                         Path                 = 'C:\Program Files\WindowsPowerShell\Modules\TestModule\1.0.0\TestModule.psm1'
    #                         ParentPath           = 'C:\Program Files\WindowsPowerShell\Modules\TestModule\1.0.0'
    #                         ImplementedAs        = $null
    #                         CompanyName          = $null
    #                         Properties           = @( @{
    #                                 Name         = 'Property1'
    #                                 Type         = 'String'
    #                                 Description  = 'Description1'
    #                                 Value        = 'Value1'
    #                                 PropertyType = 'System.String'
    #                             } )
    #                     }
    #                 }
    #             }

    #             Set-Content -Path $cacheFilePath -Value @( $content | ConvertTo-Json -Depth 5 -Compress )
    #             $result = ReadDscPsAdapterSchema -ReturnTypeInfo
    #             $result | Should -Be 'Test/TestResource'
    #         }
    #     }
    # }
}
