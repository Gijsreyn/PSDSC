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
        $commandData = GetDscCommandIndex -CommandName $MyInvocation.MyCommand.Name

        $arguments = BuildDscInput -Command $commandData.Command -Operation $commandData.Operation -ResourceName $ResourceName

        # TODO: we can still make a call to the resource manifest and see if input is required
    }

    process
    {
        # get the System.Diagnostics.Process object
        $process = GetNetProcessObject -Arguments $arguments

        # start the process
        $inputObject = StartNetProcessObject -Process $process
    }

    end
    {
        # return
        $inputObject
    }
}
