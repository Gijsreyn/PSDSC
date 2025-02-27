$Script:IsPowerShellCore = $PSVersionTable.PSEdition -eq 'Core'

if ($Script:IsPowerShellCore -and $IsWindows)
{
    Import-Module -Name 'PSDesiredStateConfiguration' -MinimumVersion 2.0.7 -Prefix 'Pwsh' -ErrorAction SilentlyContinue
}

function CreateCompletionResult($text)
{
    $CompletionText = $text
    $ListItemText = $text
    $ResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
    $ToolTip = $text

    return [System.Management.Automation.CompletionResult]::new($CompletionText, $ListItemText, $ResultType, $ToolTip)
}
