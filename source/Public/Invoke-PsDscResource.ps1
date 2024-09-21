function Invoke-PsDscResource
{
    <#
    .SYNOPSIS
        Invoke DSC version 3 resource using the command-line utility

    .DESCRIPTION
        The function Invoke-PsDscResource invokes Desired State Configuration version 3 resources calling the executable.

    .PARAMETER ResourceName
        The resource name to execute.

    .PARAMETER Operation
        The operation capability to execute e.g. 'Set'.

    .PARAMETER ResourceInput
        The resource input to provide. Supports JSON, YAML path and PowerShell hash table.

    .EXAMPLE
        PS C:\> Invoke-PsDscResource -ResourceName Microsoft.Windows/RebootPending -Operation Get

        Execute Microsoft.Windows/RebootPending resource on Windows system to check if there is a pending reboot

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Required for down-level function(s).')]
    param
    (
        [Parameter(Mandatory = $true)]
        [Alias('Name')]
        [ArgumentCompleter([DscResourceCompleter])]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Get', 'Set', 'Test', 'Delete')]
        [System.String]
        $Operation,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ArgumentCompleter([DscResourceInputCompleter])]
        [AllowNull()]
        [object]
        $ResourceInput
    )

    begin
    {
        Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)

        # get the bound parameters without common
        $boundParameters = GetBoundParameters -BoundParameters $PSBoundParameters @("ResourceName", "ResourceInput")

        Write-Verbose ($boundParameters | ConvertTo-Json | Out-String)
    }

    process
    {
        switch ($Operation)
        {
            'Get'
            {
                $inputObject = GetDscResourceCommand @boundParameters
            }
            'Set'
            {
                $inputObject = SetDscResourceCommand @boundParameters
            }
            'Test'
            {
                $inputobject = TestDscResourceCommand @boundParameters
            }
            'Delete'
            {
                $inputobject = RemoveDscResourceCommand @boundParameters
            }
            default
            {
                $inputObject = FindDscResourceCommand @boundParameters
            }
        }
    }

    end
    {
        Write-Verbose ("Ended: {0}" -f $MyInvocation.MyCommand.Name)
        $inputObject
    }
}
