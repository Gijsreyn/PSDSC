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
        $commandName = GetDscCommandIndex -CommandName $MyInvocation.MyCommand.Name -IncludeCommand

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
        if ($PSCmdlet.ShouldProcess("Executing: '{0}'"))
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
