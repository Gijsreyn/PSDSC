Function ConvertToHashString
{
    <#
    .SYNOPSIS
        Convert hashtable to string.

    .DESCRIPTION
        The function ConvertToHashString converts a hashtable to a string.

    .PARAMETER HashTable
        The hashtable to convert.

    .EXAMPLE
        PS C:\> ConvertToHashString -HashTable @{ 'key' = 'value' }

        Returns:
        @{key = value}

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$HashTable
    )
    $first = $true
    foreach ($pair in $HashTable.GetEnumerator())
    {
        if ($first)
        {
            $first = $false
        }
        else
        {
            $output += ';'
        }

        $output += "'{0}' = '{1}'" -f $($pair.key), $($pair.Value)
    }

    $output = [System.String]::Concat('@{', $output, '}')

    return $output
}
