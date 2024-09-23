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

Describe 'BuildDscInput' {
    Context 'Build Desired State Configuration config input using path input(s)' {
        It 'Should be able to return config string with path parameter' {
            InModuleScope -ScriptBlock {
                $yamlPath = (Join-Path -Path $TestDrive -ChildPath 'registry.example.config.yaml')
                New-Item -Path $yamlPath -ItemType File -ErrorAction SilentlyContinue
                $content = '$schema: https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json
        resources:
        - name: Using registry
        type: Microsoft.Windows/Registry
        properties:
          keyPath: "HKCU"
        '
                Set-Content -Path $yamlPath -Value $content -ErrorAction SilentlyContinue
                $res = BuildDscInput -Command config -Operation get -ResourceInput $yamlPath
                $res | Should -BeExactly "config get --path $yamlPath"
            }
        }
        It 'Should be able to return config string with path string and parameter file' {
            InModuleScope -ScriptBlock {
                $yamlPath = (Join-Path -Path $TestDrive -ChildPath 'registry.example.config.yaml')
                $yamlParameterFile = (Join-Path -Path $TestDrive -ChildPath 'registry.example.config.parameters.yaml')
                New-Item -Path $yamlParameterFile -ItemType File -ErrorAction SilentlyContinue
                $content = 'parameters:
keyPath: "HKCU"
'
                Set-Content -Path $yamlParameterFile -Value $content
                $res = BuildDscInput -Command config -Operation get -ResourceInput $yamlPath -Parameter $yamlParameterFile
                $res | Should -BeExactly "config --parameters-file $yamlParameterFile get --path $yamlPath"
            }
        }
    }

    Context 'Build Desired State Configuration config input using document or input' {
        It 'Should be able to return config string with document input' {
            InModuleScope -ScriptBlock {
                $config = @{
                    '$schema' = 'https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json'
                    resources = @(
                        @{
                            name       = 'Using registry'
                            type       = 'Microsoft.Windows/Registry'
                            properties = @{
                                keyPath = 'HKCU'
                            }
                        }
                    )
                }

                $res = BuildDscInput -Command config -Operation get -ResourceInput $config
                $res | Should -BeLike "config get --document *"
            }
        }
        It 'Should be able to return config string with document input and parameters input' {
            InModuleScope -ScriptBlock {
                $config = @{
                    '$schema'  = 'https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json'
                    parameters = @{
                        keyPath = @{
                            type         = 'string'
                            defaultValue = 'HKCU'
                        }
                    }
                    resources  = @(
                        @{
                            name       = 'Using registry'
                            type       = 'Microsoft.Windows/Registry'
                            properties = @{
                                keyPath = "[parameters('keyPath')]"
                            }
                        }
                    )
                }

                $parameter = @{parameters = @{keyPath = 'HKCU' } }

                $json = ($parameter | ConvertTo-Json -Depth 10 -Compress | ConvertTo-Json)

                $res = BuildDscInput -Command config -Operation get -ResourceInput $config -Parameter $parameter
                $res | Should -BeLike "config --parameters $json get --document *"
            }
        }
        It 'Should be able to return config string with JSON input and parameters input' {
            InModuleScope -ScriptBlock {
                $json = @'
{
  "$schema": "https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json",
  "parameters": {
    "keyPath": {
      "defaultValue": "HKCU",
      "type": "string"
    }
  },
  "resources": [
    {
      "properties": {
        "keyPath": "[parameters('keyPath')]"
      },
      "name": "Using registry",
      "type": "Microsoft.Windows/Registry"
    }
  ]
}
'@
                $parameter = @{parameters = @{keyPath = 'HKCU' } }

                $json = ($parameter | ConvertTo-Json -Depth 10 -Compress | ConvertTo-Json)

                $res = BuildDscInput -Command config -Operation get -ResourceInput $json -Parameter $parameter
                $res | Should -BeLike "config --parameters $json get --document *"
            }
        }
        It 'Should be able to return config string with YAML input' {
            InModuleScope -ScriptBlock {
                $yamlInput = @'
$schema: https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json
resources:
  - name: Using registry
    type: Microsoft.Windows/Registry
    properties:
      keyPath: HKCU
'@

                $res = BuildDscInput -Command config -Operation get -ResourceInput $yamlInput
                $res | Should -BeLike "config get --document *"
            }
        }
        It 'Should be able to return config string with YAML input and parameters input' {
            InModuleScope -ScriptBlock {
                $yamlInput = @'
$schema: https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json
parameters:
  keyPath:
    defaultValue: HKCU
    type: string
resources:
  - name: Using registry
    type: Microsoft.Windows/Registry
    properties:
      keyPath: "[parameters('keyPath')]"
'@
                $parameter = @'
parameters:
  keyPath: HKCU
'@

                $res = BuildDscInput -Command config -Operation get -ResourceInput $yamlInput -Parameter $parameter
                $res | Should -BeLike "config --parameters * get --document *"
            }
        }
    }
}

# TODO: write test for YAML
