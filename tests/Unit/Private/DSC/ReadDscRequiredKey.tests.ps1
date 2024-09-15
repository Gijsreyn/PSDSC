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
}

Describe 'ReadDscRequiredKey' {
    Context 'Reads the DSC schema key(s)' {
        It 'Should be able to read dsc keys' {
            InModuleScope -ScriptBlock {
                $resolved = ResolveDscExe
                # know that this is command-based dsc resource
                $resourceManifest = Join-Path (Split-Path -Path $resolved) -ChildPath 'registry.dsc.resource.json'

                $result = ReadDscRequiredKey -ResourceManifest $resourceManifest
                $result.type | Should -BeLike "*Registry"
                $result.resourceInput | Should -Not -BeNullOrEmpty
                $result.GetType().Name | Should -Be 'ResourceManifest'
            }
        }
    }
}
