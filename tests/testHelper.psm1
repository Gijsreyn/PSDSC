<#
    .SYNOPSIS
        This module contains helper functions for the tests.
#>
function Complete
{
    [OutputType([System.Management.Automation.CompletionResult])]
    param([string] $Expression)

    end
    {
        [System.Management.Automation.CommandCompletion]::CompleteInput(
            $Expression,
            $Expression.Length,
            $null).CompletionMatches
    }
}
