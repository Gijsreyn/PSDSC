function NewEnvironmentVariableObject
{
    <#
    .SYNOPSIS
    A PowerShell module to handle environment variables, supporting variable expansion. This function handles GETTING environment variables.

    .DESCRIPTION
    This module is capable of Retrieving Environment Variables in any scope (Process, User, Machine). It will return the value of the Envrionment Variable.

    .PARAMETER Name
    [String] Specify the name of the Environment Variable to retrieve.

    .PARAMETER Value
        What is the value to be set.

    .PARAMETER Scope
    [System.EnvironmentVariableTarget], [String]
    Specify the scope to search for the target Environment Variable.

    Process : Environment Variables in the running process.

    User    : Environment Variables in the User Scope affect the Global Environment Variables for the current user.

    Machine : Environment Variables in the Machine Scope change the settings in the registry for all users.

    .PARAMETER ValueType
        The value type e.g. String.

    .PARAMETER BeforeExpansion
        The value before it got expanded.

    .EXAMPLE
        PS C:\> NewEnvironmentVariableObject

    .NOTES
        Site: https://github.com/rbleattler/xEnvironmentVariables
    #>
    param
    (
        [OutputType([HashTable])]
        [Parameter(Mandatory)]
        [ValidatePattern("[^=]+")]
        $Name,
        [Parameter()]
        [AllowNull()]
        [String]
        $Value,
        [Parameter(Mandatory)]
        [System.EnvironmentVariableTarget]
        $Scope,
        [Parameter()]
        [AllowNull()]
        [ValidateSet("String", "ExpandString", $null)]
        [String]
        $ValueType,
        [Parameter()]
        [AllowNull()]
        [String]
        $BeforeExpansion
    )

    $OutPut = [PSCustomObject]@{
        Name            = $Name
        Value           = $Value
        Scope           = $Scope
        ValueType       = $ValueType
        BeforeExpansion = $BeforeExpansion
    }
    $OutPut
}
