class VersionCompleter : System.Management.Automation.IArgumentCompleter
{
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $wordToComplete,
        [System.Management.Automation.Language.CommandAst] $CommandAst,
        [Collections.IDictionary] $fakeBoundParameters
    )
    {
        [array]$dscVersions = (Get-DscVersion -UseGitHub) | Where-Object { $_ -like "$wordToComplete*" }

        $list = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()

        foreach ($version in $dscVersions)
        {
            $CompletionText = $version
            $ListItemText = $version
            $ResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            $ToolTip = $version

            $obj = [System.Management.Automation.CompletionResult]::new($CompletionText, $ListItemText, $ResultType, $Tooltip)
            $list.add($obj)
        }

        return $list

    }
}
