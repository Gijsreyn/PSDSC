BeforeAll {
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


Describe 'ReadDscPsAdapterSchemaProperty' {
    Context 'When Properties have mandatory fields' {
        It 'Returns the correct resource input list' {
            InModuleScope -ScriptBlock {
                $properties = @(
                    [PSCustomObject]@{ Name = 'Property1'; PropertyType = '[string]'; IsMandatory = $true },
                    [PSCustomObject]@{ Name = 'Property2'; PropertyType = '[int]'; IsMandatory = $false }
                )

                $result = ReadDscPsAdapterSchemaProperty -Properties $properties
                $result[0] | Should -Contain '{"Property1":"<string>"}'
                $result[1] | Should -Contain '{"Property1":"<string>","Property2":"<int>"}' # should contain other example
            }
        }

        It 'Builds the correct hash table when BuildHashTable is specified' {
            InModuleScope -ScriptBlock {
                $properties = @(
                    [PSCustomObject]@{ Name = 'Property1'; PropertyType = '[string]'; IsMandatory = $true },
                    [PSCustomObject]@{ Name = 'Property2'; PropertyType = '[int]'; IsMandatory = $false }
                )

                $result = ReadDscPsAdapterSchemaProperty -Properties $properties -BuildHashTable
                $result[0] | Should -Contain "@{'Property1' = '<string>'}"
                $result[1] | Should -Contain "@{'Property1' = '<string>';'Property2' = '<int>'}"
            }
        }
    }

    Context 'When Properties do not have mandatory fields' {
        It 'Returns the correct resource input list' {
            InModuleScope -ScriptBlock {
                $properties = @(
                    [PSCustomObject]@{ Name = 'Property1'; PropertyType = '[string]'; IsMandatory = $false },
                    [PSCustomObject]@{ Name = 'Property2'; PropertyType = '[int]'; IsMandatory = $false }
                )

                $result = ReadDscPsAdapterSchemaProperty -Properties $properties
                $result | Should -Contain '{}' # empty string
                $result | Should -Contain '{"Property1":"<string>","Property2":"<int>"}'
            }

        }

        It 'Builds the correct hash table when BuildHashTable is specified' {
            InModuleScope -ScriptBlock {
                $properties = @(
                    [PSCustomObject]@{ Name = 'Property1'; PropertyType = '[string]'; IsMandatory = $false },
                    [PSCustomObject]@{ Name = 'Property2'; PropertyType = '[int]'; IsMandatory = $false }
                )

                $result = ReadDscPsAdapterSchemaProperty -Properties $properties -BuildHashTable

                $resultObject = Invoke-Expression $result[1]
                $resultObject | Should -BeOfType 'hashtable'
                $resultObject['Property1'] | Should -Be '<string>'
                $resultObject['Property2'] | Should -Be '<int>'
            }
        }
    }
}
