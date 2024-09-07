function Test-Dsc
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param ()

    $dsc = (Get-Command dsc -ErrorAction SilentlyContinue)
    if ($dsc)
    {
        $true
    }
    else
    {
        $false
    }
}
