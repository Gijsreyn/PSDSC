<#
    .SYNOPSIS
        Converts a secure string to a plain text string.

    .DESCRIPTION
        This function converts a secure string to a plain text string by using
        the SecureStringToBSTR method and then converts the resulting BSTR
        to a string using PtrToStringBSTR. The function ensures that the
        memory allocated for the BSTR is properly freed to prevent memory leaks.
        The method works in both Windows PowerShell and PowerShell.

    .PARAMETER SecureString
        The secure string that should be converted to a plain text string.

    .EXAMPLE
        $securePassword = ConvertTo-SecureString -String 'P@ssw0rd' -AsPlainText -Force
        $plainTextPassword = Convert-SecureStringAsPlainText -SecureString $securePassword

        This example converts a secure string to a plain text string.

    .EXAMPLE
        $credential = Get-Credential
        $plainTextPassword = Convert-SecureStringAsPlainText -SecureString $credential.Password

        This example gets credentials from the user and converts the password
        secure string to a plain text string.

    .NOTES
        This function should be used with caution as it exposes secure strings
        as plain text which can be a security risk. Only use this function when
        absolutely necessary and in a secure context.
#>
function Convert-SecureStringAsPlainText
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Security.SecureString]
        $SecureString
    )

    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)

    try
    {
        $plainText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    }
    finally
    {
        if ($bstr -ne [IntPtr]::Zero)
        {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }
    }

    return $plainText
}
