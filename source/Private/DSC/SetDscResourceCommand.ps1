function SetDscResourceCommand
{
    <#
    .SYNOPSIS
        Run set operation against DSC resource

    .DESCRIPTION
        The function SetDscResourceCommand sets a DSC resource

    .PARAMETER ResourceName
        The resource name to set against.

    .PARAMETER ResourceInput
        The resource input to provide. Supports JSON, path and PowerShell scripts.

    .EXAMPLE
        PS C:\> SetDscResourceCommand -ResourceName Microsoft.Windows/Registry -ResourceInput @{keyPath = 'HKCU\Microsoft'}

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
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

        $arguments = BuildDscInput -SubCommand $commandData.Command -Operation $commandData.Operation -ResourceInput $ResourceInput -ResourceName $ResourceName

        # TODO: we can still make a call to the resource manifest and see if input is required
    }

    process
    {
        # get the System.Diagnostics.Process object
        $process = GetNetProcessObject -SubCommand $arguments

        # start the process
        if ($PSCmdlet.ShouldProcess(("'{0}' with input: [{1}]" -f $ResourceName, $resourceInput)))
        {
            $inputObject = StartNetProcessObject -Process $process
        }
    }

    end
    {
        # return
        $inputObject
    }
}
