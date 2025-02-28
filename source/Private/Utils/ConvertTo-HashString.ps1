Function ConvertTo-HashString
{
    <#
    .SYNOPSIS
        Convert hashtable to string.

    .DESCRIPTION
        The function ConvertTo-HashString converts a hashtable to a string.

    .PARAMETER HashTable
        The hashtable to convert.

    .EXAMPLE
        PS C:\> ConvertTo-HashString -HashTable @{ 'key' = 'value' }

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
        [System.Collections.Specialized.OrderedDictionary]$HashTable
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
