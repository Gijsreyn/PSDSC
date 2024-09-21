function ConvertToDscObject
{
    <#
    .SYNOPSIS
        Convert DSC configuration documents to object

    .DESCRIPTION
        The function ConvertToDscObject converts Configuration Document(s) to an hashtable object

    .PARAMETER Path
        The path to a valid Configuration Document.

    .PARAMETER Content
        The content to a valid DSC Configuration Document.

    .EXAMPLE
        PS C:\> $path = 'myConfig.ps1'
        PS C:\> ConvertToDscObject -Path $path

    .NOTES
        Credits to: https://github.com/microsoft/DSCParser/tree/master
    #>
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    [OutputType([System.Array])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Function converted from Microsoft.')]
    param
    (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Path')]
        [ValidateScript({
                if (-Not ($_ | Test-Path) )
                {
                    throw "File or folder does not exist"
                }
                if (-Not ($_ | Test-Path -PathType Leaf) )
                {
                    throw "The Path argument must be a file. Folder paths are not allowed."
                }
                if (($_ | Get-Item).Extension -ne '.ps1' )
                {
                    throw "The Path argument must be a file and end with '.ps1'. Folder paths are not allowed."
                }
                return $true
            })]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Content')]
        [System.String]
        $Content
    )

    $result = @()
    $Tokens = $null
    $ParseErrors = $null


    # Use the AST to parse the DSC configuration
    if (-not [System.String]::IsNullOrEmpty($Path) -and [System.String]::IsNullOrEmpty($Content))
    {
        if (-not ([System.IO.Path]::GetExtension($Path)))
        {
            Throw "The file must end with .ps1."
        }
        $Content = Get-Content $Path -Raw
    }

    # Remove the module version information.
    $start = $Content.ToLower().IndexOf('import-dscresource')
    if ($start -ge 0)
    {
        $end = $Content.IndexOf("`n", $start)
        if ($end -gt $start)
        {
            $start = $Content.ToLower().IndexOf("-moduleversion", $start)
            if ($start -ge 0 -and $start -lt $end)
            {
                $Content = $Content.Remove($start, $end - $start)
            }
        }
    }

    # Rename the configuration node to ensure a valid name is used.
    $start = $Content.ToLower().IndexOf("`nconfiguration")
    if ($start -lt 0)
    {
        $start = $Content.ToLower().IndexOf(' configuration ')
    }
    if ($start -ge 0)
    {
        $end = $Content.IndexOf("`n", $start)
        if ($end -gt $start)
        {
            $start = $Content.ToLower().IndexOf(' ', $start + 1)
            if ($start -ge 0 -and $start -lt $end)
            {
                $Content = $Content.Remove($start, $end - $start)
                $Content = $Content.Insert($start, " TempDSCParserConfiguration")
            }
        }
    }

    $AST = [System.Management.Automation.Language.Parser]::ParseInput($Content, [ref]$Tokens, [ref]$ParseErrors)

    # Look up the Configuration definition ("")
    $Config = $AST.Find({ $Args[0].GetType().Name -eq 'ConfigurationDefinitionAst' }, $False)

    # Retrieve information about the DSC Modules imported in the config
    # and get the list of their associated resources.
    $ModulesToLoad = @()
    foreach ($statement in $config.body.ScriptBlock.EndBlock.Statements)
    {
        if ($null -ne $statement.CommandElements -and $null -ne $statement.CommandElements[0].Value -and `
                $statement.CommandElements[0].Value -eq 'Import-DSCResource')
        {
            $currentModule = @{}
            for ($i = 0; $i -le $statement.CommandElements.Count; $i++)
            {
                if ($statement.CommandElements[$i].ParameterName -eq 'ModuleName' -and `
                    ($i + 1) -lt $statement.CommandElements.Count)
                {
                    $moduleName = $statement.CommandElements[$i + 1].Value
                    $currentModule.Add('ModuleName', $moduleName)
                }
                elseif ($statement.CommandElements[$i].ParameterName -eq 'ModuleVersion' -and `
                    ($i + 1) -lt $statement.CommandElements.Count)
                {
                    $moduleVersion = $statement.CommandElements[$i + 1].Value
                    $currentModule.Add('ModuleVersion', $moduleVersion)
                }
            }
            $ModulesToLoad += $currentModule
        }
    }
    $DSCResources = @()
    foreach ($moduleToLoad in $ModulesToLoad)
    {
        $loadedModuleTest = Get-Module -Name $moduleToLoad.ModuleName -ListAvailable | Where-Object -FilterScript { $_.Version -eq $moduleToLoad.ModuleVersion }

        if ($null -eq $loadedModuleTest -and -not [System.String]::IsNullOrEmpty($moduleToLoad.ModuleVersion))
        {
            throw "Module {$($moduleToLoad.ModuleName)} version {$($moduleToLoad.ModuleVersion)} specified in the configuration isn't installed on the machine/agent. Install it by running: Install-Module -Name '$($moduleToLoad.ModuleName)' -RequiredVersion '$($moduleToLoad.ModuleVersion)'"
        }
        else
        {
            Write-Verbose -Message ("Retrieving module: {0}" -f $moduleToLoad.ModuleName)
            if ($Script:IsPowerShellCore)
            {
                $currentResources = Get-PwshDscResource -Module $moduleToLoad.ModuleName
            }
            else
            {
                $currentResources = Get-DSCResource -Module $moduleToLoad.ModuleName
            }

            if (-not [System.String]::IsNullOrEmpty($moduleToLoad.ModuleVersion))
            {
                $currentResources = $currentResources | Where-Object -FilterScript { $_.Version -eq $moduleToLoad.ModuleVersion }
            }
            $DSCResources += $currentResources
        }
    }

    # Drill down
    # Body.ScriptBlock is the part after "Configuration <InstanceName> {"
    # EndBlock is the actual code within that Configuration block
    # Find the first DynamicKeywordStatement that has a word "Node" in it, find all "NamedBlockAst" elements, these are the DSC resource definitions
    try
    {
        $resourceInstances = $Config.Body.ScriptBlock.EndBlock.Statements.Find({ $Args[0].GetType().Name -eq 'DynamicKeywordStatementAst' -and $Args[0].CommandElements[0].StringConstantType -eq 'BareWord' -and $Args[0].CommandElements[0].Value -eq 'Node' }, $False).commandElements[2].ScriptBlock.Find({ $Args[0].GetType().Name -eq 'NamedBlockAst' }, $False).Statements
    }
    catch
    {
        $resourceInstances = $Config.Body.ScriptBlock.EndBlock.Statements | Where-Object -FilterScript { $null -ne $_.CommandElements -and $_.CommandElements[0].Value -ne 'Import-DscResource' }
    }

    # Get the name of the configuration.
    $configurationName = $Config.InstanceName.Value

    $totalCount = 1
    foreach ($resource in $resourceInstances)
    {
        $currentResourceInfo = @{}

        # CommandElements
        # 0 - Resource Type
        # 1 - Resource Instance Name
        # 2 - Key/Pair Value list of parameters.
        $resourceType = $resource.CommandElements[0].Value
        $resourceInstanceName = $resource.CommandElements[1].Value

        $percent = ($totalCount / ($resourceInstances.Count) * 100)
        Write-Progress -Status "[$totalCount/$($resourceInstances.Count)] $resourceType - $resourceInstanceName" `
            -PercentComplete $percent `
            -Activity "Parsing Resources"
        $currentResourceInfo.Add("ResourceName", $resourceType)
        $currentResourceInfo.Add("ResourceInstanceName", $resourceInstanceName)
        $currentResourceInfo.Add("ModuleName", $ModulesToLoad.ModuleName)
        $currentResourceInfo.Add("ConfigurationName", $configurationName)
        $adapter = 'Microsoft.DSC/PowerShell'
        if ($PSVersionTable.PSEdition -ne 'Core')
        {
            $adapter = 'Microsoft.Windows/WindowsPowerShell'
        }
        $currentResourceInfo.Add("Type", $adapter)

        # Get a reference to the current resource.
        $currentResource = $DSCResources | Where-Object -FilterScript { $_.Name -eq $resourceType }

        # Loop through all the key/pair value
        foreach ($keyValuePair in $resource.CommandElements[2].KeyValuePairs)
        {
            $isVariable = $false
            $key = $keyValuePair.Item1.Value

            if ($null -ne $keyValuePair.Item2.PipelineElements)
            {
                if ($null -eq $keyValuePair.Item2.PipelineElements.Expression.Value)
                {
                    if ($null -ne $keyValuePair.Item2.PipelineElements.Expression)
                    {
                        if ($keyValuePair.Item2.PipelineElements.Expression.StaticType.Name -eq 'Object[]')
                        {
                            $value = $keyValuePair.Item2.PipelineElements.Expression.SubExpression
                            $newValue = @()
                            foreach ($expression in $value.Statements.PipelineElements.Expression)
                            {
                                if ($null -ne $expression.Elements)
                                {
                                    foreach ($element in $expression.Elements)
                                    {
                                        if ($null -ne $element.VariablePath)
                                        {
                                            $newValue += "`$" + $element.VariablePath.ToString()
                                        }
                                        elseif ($null -ne $element.Value)
                                        {
                                            $newValue += $element.Value
                                        }
                                    }
                                }
                                else
                                {
                                    $newValue += $expression.Value
                                }
                            }
                            $value = $newValue
                        }
                        else
                        {
                            $value = $keyValuePair.Item2.PipelineElements.Expression.ToString()
                        }
                    }
                    else
                    {
                        $value = $keyValuePair.Item2.PipelineElements.Parent.ToString()
                    }

                    if ($value.GetType().Name -eq 'String' -and $value.StartsWith('$'))
                    {
                        $isVariable = $true
                    }
                }
                else
                {
                    $value = $keyValuePair.Item2.PipelineElements.Expression.Value
                }
            }

            # Retrieve the current property's type based on the resource's schema.
            $currentPropertyInResourceSchema = $currentResource.Properties | Where-Object -FilterScript { $_.Name -eq $key }
            $valueType = $currentPropertyInResourceSchema.PropertyType

            # If the value type is null, then the parameter doesn't exist
            # in the resource's schema and we throw a warning
            $propertyFound = $true
            if ($null -eq $valueType)
            {
                $propertyFound = $false
                Write-Warning "Defined property {$key} was not found in resource {$resourceType}"
            }

            if ($propertyFound)
            {
                # If the current property is not a CIMInstance
                if (-not $valueType.StartsWith('[MSFT_') -and `
                        $valueType -ne '[string]' -and `
                        $valueType -ne '[string[]]' -and `
                        -not $isVariable)
                {
                    # Try to parse the value based on the retrieved type.
                    $scriptBlock = @"
                                    `$typeStaticMethods = $valueType | gm -static
                                    if (`$typeStaticMethods.Name.Contains('TryParse'))
                                    {
                                        $valueType::TryParse(`$value, [ref]`$value) | Out-Null
                                    }
"@
                    Invoke-Expression -Command $scriptBlock | Out-Null
                }
                elseif ($valueType -eq '[String]' -or $isVariable)
                {
                    if ($isVariable -and [Boolean]::TryParse($value.TrimStart('$'), [ref][Boolean]))
                    {
                        if ($value -eq "`$true")
                        {
                            $value = $true
                        }
                        else
                        {
                            $value = $false
                        }
                    }
                    else
                    {
                        $value = $value
                    }
                }
                elseif ($valueType -eq '[string[]]')
                {
                    # If the property is an array but there's only one value
                    # specified as a string (not specifying the @()) then
                    # we need to create the array.
                    if ($value.GetType().Name -eq 'String' -and -not $value.StartsWith('@('))
                    {
                        $value = @($value)
                    }
                }
                else
                {
                    $isArray = $false
                    if ($keyValuePair.Item2.ToString().StartsWith('@('))
                    {
                        $isArray = $true
                    }
                    if ($isArray)
                    {
                        $value = @($value)
                    }
                }
                $currentResourceInfo.Add($key, $value) | Out-Null
            }
        }

        $result += $currentResourceInfo
        $totalCount++
    }
    Write-Progress -Completed `
        -Activity "Parsing Resources"

    return [System.Array]$result
}
