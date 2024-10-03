BeforeAll {
    # TODO: Find way how to install / uninstall yayaml or unload from current session
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

    # trigger clean up of adapter PS cache
    if ($source = Get-Command -name dsc -ErrorAction SilentlyContinue)
    {
        $psAdapterFile = Join-Path (Split-Path $Source.Source -Parent) 'psDscAdapter' 'powershell.resource.ps1'

        if (Test-Path $psAdapterFile -ErrorAction SilentlyContinue)
        {
            # it might not be helpful for others
            & $psAdapterFile -Operation ClearCache
        }
    }
}

Describe 'GetDscResourceDetail' {
    Context 'Default Path' {
        It 'Works with default path' {
            InModuleScope -ScriptBlock {
                $result = GetDscResourceDetail
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }

    Context 'Custom Path' {
        It 'Works with a custom path' {
            InModuleScope -ScriptBlock {
                if (TestWinGetModule)
                {
                    # TODO: life is difficult with WinGet
                    $version = (GetDscVersion) -replace "preview.", ""
                    $architecture = ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture).ToString().ToLower()
                    $Path = Join-Path $env:ProgramFiles 'WindowsApps' "Microsoft.DesiredStateConfiguration-Preview_3.0.$version.0_$architecture`__8wekyb3d8bbwe" 'dsc.exe'
                    if ($env:TF_BUILD)
                    {

                    }
                }
                $result = GetDscResourceDetail -Path $Path
                $result | Should -Not -BeNullOrEmpty
            }

        }
    }

    Context 'Invalid Path' {
        It 'Throws an error when the path does not exist' {
            InModuleScope -ScriptBlock {
                $invalidPath = Join-Path $env:USERPROFILE -ChildPath 'Idonotexist.exe'
                { GetDscResourceDetail -Path $invalidPath } | Should -Throw -ErrorId "Path does not exist: $invalidPath. Please ensure the path is correct to 'dsc.exe'."
            }
        }
    }

    Context 'JSON File Processing' {
        It 'Processes JSON files correctly with cache' -Skip:(!$IsWindows) {
            InModuleScope -ScriptBlock {
                $cacheFilePath = Join-Path $env:LocalAppData "dsc" "PSAdapterCache.json"

                $addedContent = [PSCustomObject]@{
                    Type            = 'Test/TestResource'
                    DscResourceInfo = [PSCustomObject]@{
                        ImplementationDetail = 1
                        FriendlyName         = 'TestResource'
                        Name                 = 'TestResource'
                        Module               = 'TestModule.psm1'
                        Version              = '1.0.0'
                        Path                 = 'C:\Program Files\WindowsPowerShell\Modules\TestModule\1.0.0\TestModule.psm1'
                        ParentPath           = 'C:\Program Files\WindowsPowerShell\Modules\TestModule\1.0.0'
                        ImplementedAs        = $null
                        CompanyName          = $null
                        Properties           = @( @{
                                Name         = 'Property1'
                                Type         = 'String'
                                Description  = 'Description1'
                                Value        = 'Value1'
                                PropertyType = 'System.String'
                            } )
                    }
                    LastWriteTimes  = @{
                        'TestModule.psm1' = (Get-Date)

                    }
                }

                if (-not (Test-Path $cacheFilePath) -and (Get-Item $cacheFilePath -ErrorAction SilentlyContinue).Length -eq 0)
                {
                    $jsonContent = @{ResourceCache = @($addedContent) } | ConvertTo-Json -Depth 5
                    Set-Content -Path $cacheFilePath -Value $jsonContent
                }
                else
                {
                    $existingContent = Get-Content -Path $cacheFilePath -Raw | ConvertFrom-Json
                    if (-not $existingContent.ResourceCache.Type -ne 'Test/TestResource')
                    {
                        $inputObject = [System.Collections.Generic.List[psobject]]::new()

                        # add the new
                        $inputObject.Add($addedContent)

                        # add the existing
                        $inputObject.Add($existingContent.ResourceCache)

                        # overwrite the existing property
                        $existingContent | Add-Member -MemberType NoteProperty -Name ResourceCache -Value $inputObject -Force

                        Set-Content -Path $cacheFilePath -Value ($existingContent | ConvertTo-Json -Depth 10)
                    }
                }

                $result = GetDscResourceDetail
                $result | Should -Contain "Test/TestResource"
            }
        }
    }

    Context 'Exclusion' {
        It 'Excludes specified JSON content' {
            InModuleScope -ScriptBlock {
                $result = GetDscResourceDetail -Exclude @{kind = 'Group' }
                $result | Should -not -Contain 'Microsoft.DSC/Group'
                $result | Should -not -Contain 'Microsoft.DSC/Assertion'
            }
        }
    }
}
