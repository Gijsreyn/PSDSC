function GetBoundParameters
{
    <#
    .SYNOPSIS
        Helper function that returns a hashtable of the GOOD bound parameters needed for calling other function

    .DESCRIPTION
        The function GetBoundParameters helps to create a hash table used for other functions

    .PARAMETER BoundParameters
        The bound parameters to check

    .PARAMETER GoodKeys
        The good keys to check in bound parameters

    .EXAMPLE
        PS C:\> GetBoundParameters -BoundParameters $PSBoundParameters -GoodKeys @("ResourceName", "ResourceInput")


    .NOTES
        Tags: Parameters
    #>
    [OutputType([hashtable])]
    [CmdletBinding()]
    Param (
        [AllowNull()]
        [object]
        $BoundParameters,

        [System.Array]
        $GoodKeys
    )

    $ConfigurationHelper = @{}

    foreach ($Key in $BoundParameters.Keys)
    {
        if ($GoodKeys -contains $Key)
        {
            $ConfigurationHelper[$Key] = $BoundParameters[$Key]
        }
    }

    return $ConfigurationHelper
}
