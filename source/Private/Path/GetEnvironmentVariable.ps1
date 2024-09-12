function GetEnvironmentVariable
{
    <#
    .SYNOPSIS
    A PowerShell module to handle environment variables, supporting variable expansion. This function handles GETTING environment variables.

    .DESCRIPTION
    This module is capable of Retrieving Environment Variables in any scope (Process, User, Machine). It will return the value of the Envrionment Variable.

    .PARAMETER Name
    [String] Specify the name of the Environment Variable to retrieve.

    .PARAMETER Scope
    [System.EnvironmentVariableTarget], [String]
    Specify the scope to search for the target Environment Variable.

    Process : Environment Variables in the running process.

    User    : Environment Variables in the User Scope affect the Global Environment Variables for the current user.

    Machine : Environment Variables in the Machine Scope change the settings in the registry for all users.

    .PARAMETER Expanded
    [Switch]
    If enabled any Environment Variables in the output of the command will be expanded.
    String        : A simple string value
    ExpandString  : A string value which contains unexpanded environment variables in the syntax of %VARIABLENAME%. These variables will NOT be expanded when the value is read.

    .PARAMETER ShowProperties
    [Switch] If enabled this parameter will show the Name, Value, Scope, ValueType and (if a String containing an unexpanded Environment Variable) the BeforeExpansion properties and their respective values. Otherwise only the Value will be output as a string.

    .EXAMPLE
    PS C:\> Get-EnvironmentVariable -name TestVar -Scope Machine -ShowProperties

    Name            : TestVar
    Value           : TestValue
    Scope           : Machine
    ValueType       : String
    BeforeExpansion : TestValue

    .EXAMPLE
    PS C:\> Get-EnvironmentVariable -name TestPathVar -Scope Machine -ShowProperties

    Name            : TestPathVar
    Value           : C:\Users\rblea\AppData\Local\Temp\TestValue2
    Scope           : Machine
    ValueType       : String
    BeforeExpansion : %TEMP%\TestValue2

    .EXAMPLE
    PS C:\>  Get-EnvironmentVariable -name TestPathVar -Scope Machine
    C:\Users\USER\AppData\Local\Temp\TestValue2

    .EXAMPLE
    PS C:\> Get-EnvironmentVariable -name TestPathVar -Scope Machine -Expanded
    %TEMP%\TestValue2


    .INPUTS
    [String],[System.EnvironmentVariableTarget],[Boolean]

    .OUTPUTS
    [Hashtable],[String]

    .NOTES

    .LINK
    https://github.com/rbleattler/xEnvironmentVariables

    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter()]
        [System.EnvironmentVariableTarget]
        $Scope = [System.EnvironmentVariableTarget]::Process,

        [Parameter()]
        [Switch]
        $Expanded,

        [Parameter()]
        [Switch]
        $ShowProperties
    )

    $Getter = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
    if ($null -eq $Getter)
    {
        $RawValue = $null
        $GetterType = $null
    }
    else
    {
        if ($Scope -ne "Process")
        {
            if (!$Expanded)
            {
                $AllEnvironmentVariables = Get-Item -Path (GetEnvironmentPath -Scope $Scope)
                $GetterType = $AllEnvironmentVariables.GetValueKind($Name)
            }
            else
            {
                $AllEnvironmentVariables = [System.Environment]::GetEnvironmentVariables($Scope)
                $GetterType = $Getter.GetTypeCode()
            }
            if ($GetterType -eq "ExpandString")
            {
                $RawValue = $AllEnvironmentVariables.GetValue(
                    $Name, $null, 'DoNotExpandEnvironmentNames'
                )
            }
            elseif ($GetterType -eq "String")
            {
                $RawValue = $Getter
                if ($Expanded)
                {
                    $Getter = [System.Environment]::ExpandEnvironmentVariables($Getter)
                }
            }
            else
            {
                # inappropriate kind (dword, bytes, ...)
                $RawValue = $null
                $GetterType = $null
            }
        }
        else
        {
            # $Scope -eq "Process"
            $RawValue = $null
            $GetterType = "String"
        }
    }
    $params = @{
        Name            = $Name
        Value           = $Getter
        Scope           = $Scope
        ValueType       = $GetterType
        BeforeExpansion = $RawValue
    }
    $null = NewEnvironmentVariableObject @params | Set-Variable -Name NewEnvVar

    if ($ShowProperties)
    {
        $NewEnvVar | Add-Member ScriptMethod ToString { $this.Value } -Force -PassThru
    }
    else
    {
        if (!$Expanded)
        {
            $NewEnvVar | Add-Member ScriptMethod ToString { $this.Value } -Force -PassThru | Select-Object -ExpandProperty BeforeExpansion
        }
        else
        {
            $NewEnvVar | Add-Member ScriptMethod ToString { $this.Value } -Force -PassThru | Select-Object -ExpandProperty Value
        }
    }
}
