function FindDscResourceCommand
{
    <#
    .SYNOPSIS
        Run list operation against DSC resource

    .DESCRIPTION
        The function FindDscResourceCommand lists a DSC resource / adapter

    .PARAMETER ResourceName
        The resource name to get against.

    .EXAMPLE
        PS C:\> FindDscResourceCommand -ResourceName Microsoft.PowerShell/DSC

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName
    )

    begin
    {
        $commandName = GetDscCommandIndex -CommandName $MyInvocation.MyCommand.Name
    }

    process
    {
        # simply add adapter as we dont need filtering, let it throw if it is not found
        if ($PSBoundParameters.ContainsKey('ResourceName') -and ($ResourceName))
        {
            $commandName.SubCommand.Append(" --adapter $ResourceName") | Out-Null
        }

        # get the System.Diagnostics.Process object
        $process = GetNetProcessObject -SubCommand $commandName.SubCommand.ToString()

        # start the process
        $inputObject = StartNetProcessObject -Process $process
    }
    end
    {
        # return
        $inputObject
    }
}
