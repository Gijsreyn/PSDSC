function GetDscResourceCommand
{
    <#
    .SYNOPSIS
        Run get operation against DSC resource

    .DESCRIPTION
        The function GetDscResourceCommand gets a DSC resource

    .PARAMETER ResourceName
        The resource name to get against.

    .PARAMETER ResourceInput
        The resource input to provide. Supports JSON, path and PowerShell scripts.

    .EXAMPLE
        PS C:\> GetDscResourceCommand -ResourceName Microsoft.Windows/Registry -ResourceInput @{keyPath = 'HKCU\Microsoft'}

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object]
        $ResourceInput
    )

    begin
    {
        $commandData = GetDscCommandIndex -CommandName $MyInvocation.MyCommand.Name

        $arguments = BuildDscInput -Command $commandData.Command -Operation $commandData.Operation -ResourceInput $ResourceInput -ResourceName $ResourceName

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
