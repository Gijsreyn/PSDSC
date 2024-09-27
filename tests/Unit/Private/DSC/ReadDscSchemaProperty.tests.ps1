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

Describe "ReadDscSchemaProperty" {
    Context "When SchemaObject is provided" {
        It "Should return JSON string when BuildHashTable is not specified" {
            InModuleScope -ScriptBlock {
                $schemaObject = [PSCustomObject]@{
                    required   = @("keyPath")
                    properties = [PSCustomObject]@{
                        keyPath   = "somePath"
                        valueName = "someValue"
                    }
                }

                $result = ReadDscSchemaProperty -SchemaObject $schemaObject

                $expected = @(
                    '{"keyPath":"<keyPath>"}',
                    '{"keyPath":"<keyPath>","valueName":"<valueName>"}'
                )

                $result[0] | Should -Be $expected[0]
                $result[1] | Should -Be $expected[1]
            }
        }

        It "Should return hashtable string when BuildHashTable is specified" {
            InModuleScope -ScriptBlock {
                $schemaObject = [PSCustomObject]@{
                    required   = @("keyPath")
                    properties = [PSCustomObject]@{
                        keyPath   = "somePath"
                        valueName = "someValue"
                    }
                }

                $result = ReadDscSchemaProperty -SchemaObject $schemaObject -BuildHashTable

                $expected = @(
                    "@{'keyPath' = '<keyPath>'}",
                    "@{'keyPath' = '<keyPath>';'valueName' = '<valueName>'}"
                )

                $result[0] | Should -Be $expected[0]
                $result[1] | Should -Be $expected[1]
            }
        }
    }

    Context "When SchemaObject is empty" {
        It "Should return empty array" {
            InModuleScope -ScriptBlock {
                $schemaObject = [PSCustomObject]@{
                    required   = @()
                    properties = [PSCustomObject]@{}
                }

                $result = ReadDscSchemaProperty -SchemaObject $schemaObject

                $result | Should -Be @()
            }
        }
    }

    Context "When SchemaObject has only optional properties" {
        It "Should return JSON string with optional properties" {
            InModuleScope -ScriptBlock {
                $schemaObject = [PSCustomObject]@{
                    required   = @()
                    properties = [PSCustomObject]@{
                        optionalProp1 = "value1"
                        optionalProp2 = "value2"
                    }
                }

                $result = ReadDscSchemaProperty -SchemaObject $schemaObject

                $expected = @(
                    '{"optionalProp1":"<optionalProp1>","optionalProp2":"<optionalProp2>"}'
                )

                $result | Should -Be $expected
            }

        }

        It "Should return hashtable string with optional properties when BuildHashTable is specified" {
            InModuleScope -ScriptBlock {
                $schemaObject = [PSCustomObject]@{
                    required   = @()
                    properties = [PSCustomObject]@{
                        optionalProp1 = "value1"
                        optionalProp2 = "value2"
                    }
                }

                $result = ReadDscSchemaProperty -SchemaObject $schemaObject -BuildHashTable

                $expected = @(
                    "@{'optionalProp1' = '<optionalProp1>';'optionalProp2' = '<optionalProp2>'}"
                )

                $result | Should -Be $expected
            }
        }
    }
}
