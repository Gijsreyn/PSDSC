function DeleteDscResourceCommand
{
    <#
    .SYNOPSIS
        Run delete operation against DSC resource

    .DESCRIPTION
        The function DeleteDscResourceCommand deletes a DSC resource

    .PARAMETER ResourceName
        The resource name to delete against.

    .PARAMETER ResourceInput
        The resource input to provide. Supports JSON, path and PowerShell scripts.

    .EXAMPLE
        PS C:\> DeleteDscResourceCommand -ResourceName Microsoft.Windows/Registry -ResourceInput @{keyPath = 'HKCU\1'}

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
        $commandName = GetDscCommandIndex -CommandName $MyInvocation.MyCommand.Name

        # add the resource
        AddDscResource -Sb $commandName.SubCommand -ResourceName $ResourceName

        # validate input
        ValidateDscInputArgument -Sb $commandName.SubCommand -ResourceInput $ResourceInput

        # TODO: we can still make a call to the resource manifest and see if input is required
    }

    process
    {
        # get the System.Diagnostics.Process object
        $process = GetNetProcessObject -SubCommand $commandName.SubCommand.ToString()

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
