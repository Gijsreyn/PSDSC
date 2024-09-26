function Invoke-PsDscConfig
{
    <#
    .SYNOPSIS
        Invoke DSC version 3 config using the command-line utility

    .DESCRIPTION
        The function Invoke-PsDscConfig invokes Desired State Configuration version 3 configuration documents calling 'dsc.exe'.

    .PARAMETER ResourceInput
        The resource input to provide. Supports JSON, YAML path and PowerShell hash table.

    .PARAMETER Operation
        The operation capability to execute e.g. 'Set'.

    .PARAMETER Parameter
        Optionally, the parameter input to provide.

    .EXAMPLE
        PS C:\> Invoke-PsDscConfig -ResourceInput myconfig.dsc.config.yaml -Parameter myconfig.dsc.config.parameters.yaml

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Required for down-level function(s).')]
    param
    (
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object]
        $ResourceInput,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Get', 'Set', 'Test', 'Export')]
        [System.String]
        $Operation,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object]
        $Parameter
    )

    begin
    {
        Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)

        $boundParameters = GetBoundParameters -BoundParameters $PSBoundParameters -GoodKeys @('ResourceInput', 'Parameter')

        Write-Verbose ($boundParameters | ConvertTo-Json | Out-String)
    }

    process
    {
        switch ($Operation)
        {
            'Get'
            {
                $inputObject = GetDscConfigCommand @boundParameters
            }
            'Set'
            {
                $inputObject = SetDscConfigCommand @boundParameters
            }
            'Test'
            {
                $inputobject = TestDscConfigCommand @boundParameters
            }
            'Delete'
            {
                $inputobject = RemoveDscConfigCommand @boundParameters
            }
        }
    }

    end
    {
        Write-Verbose ("Ended: {0}" -f $MyInvocation.MyCommand.Name)

        # return
        return $inputObject
    }
}
