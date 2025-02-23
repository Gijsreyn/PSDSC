class ResourceCompleter : System.Management.Automation.IArgumentCompleter
{
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $wordToComplete,
        [System.Management.Automation.Language.CommandAst] $CommandAst,
        [Collections.IDictionary] $fakeBoundParameters
    )
    {
        $exe = Resolve-DscExe -ErrorAction SilentlyContinue

        $list = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()

        if ($exe)
        {
            $manifestFiles = Get-ChildItem -Path (Split-Path $exe -Parent) -Depth 1 -Filter "*.dsc.resource.json"
            foreach ($manifest in $manifestFiles)
            {
                $typeName = (Get-Content $manifest | ConvertFrom-Json -ErrorAction SilentlyContinue).type

                $CompletionText = $typeName
                $ListItemText = $typeName
                $ResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
                $ToolTip = $typeName

                $obj = [System.Management.Automation.CompletionResult]::new($CompletionText, $ListItemText, $ResultType, $Tooltip)
                $list.add($obj)
            }

            # section to include PSTypes data
            # $psTypes = ReadDscPsAdapterSchema -ReturnTypeInfo
            # $psTypes | ForEach-Object { $list.Add($_) }
        }

        return $list
    }
}

class ResourceInputCompleter : System.Management.Automation.IArgumentCompleter
{
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $wordToComplete,
        [System.Management.Automation.Language.CommandAst] $CommandAst,
        [Collections.IDictionary] $fakeBoundParameters
    )
    {
        if ($fakeBoundParameters.ContainsKey('Resource'))
        {
            [array]$Resources = GetDscRequiredKey | Where-Object {
                $_.type -eq $fakeBoundParameters.Resource
            } | Select-Object -ExpandProperty resourceInput -Unique | Sort-Object
        }
        else
        {
            [array]$Resources = @()
        }

        $list = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()

        foreach ($Resource in $Resources)
        {
            $CompletionText = "'$Resource'"
            $ListItemText = "'$Resource'"
            $ResultType = [System.Management.Automation.CompletionResultType]::ParameterValue

            $ToolTip = '{0}' -f $fakeBoundParameters.ResourceName

            $obj = [System.Management.Automation.CompletionResult]::new($CompletionText, $ListItemText, $ResultType, $Tooltip)
            $list.add($obj)
        }

        return $list

    }
}
