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

Describe "ConvertToHashString" {
    It "should convert a hashtable with one key-value pair to a string" {
        InModuleScope -ScriptBlock {
            $hashtable = @{ 'key' = 'value' }
            $expected = "@{'key' = 'value'}"
            $result = ConvertToHashString -HashTable $hashtable
            $result | Should -BeExactly $expected
        }
    }

    It "should convert a hashtable with multiple key-value pairs to a string" {
        InModuleScope -ScriptBlock {
            $hashtable = @{ 'key1' = 'value1'; 'key2' = 'value2' }
            $expected = "@{'key1' = 'value1';'key2' = 'value2'}"
            $result = ConvertToHashString -HashTable $hashtable
            $result | Should -BeExactly $expected
        }

    }

    It "should handle an empty hashtable" {
        InModuleScope -ScriptBlock {
            $hashtable = @{}
            $expected = "@{}"
            $result = ConvertToHashString -HashTable $hashtable
            $result | Should -BeExactly $expected
        }

    }

    It "should handle a hashtable with different types of values" {
        InModuleScope -ScriptBlock {
            $hashtable = [ordered]@{ 'key1' = 123; 'key2' = $true; }
            $expected = "@{'key2' = 'True';'key1' = '123'}"
            $result = ConvertToHashString -HashTable $hashtable
            $result | Should -BeExactly $expected
        }
    }
}
