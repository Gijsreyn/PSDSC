function SetDscConfigCommand
{
    <#
    .SYNOPSIS
        Run set config against DSC resource

    .DESCRIPTION
        The function SetDscResourceCommand sets a DSC config

    .PARAMETER ResourceInput
        The resource input to provide. Supports JSON, path and PowerShell scripts.

    .PARAMETER Parameter
        Optionally, the parameter input to provide.

    .EXAMPLE
         PS C:\> SetDscConfigCommand -ResourceInput myconfig.dsc.config.yaml -Parameter myconfig.dsc.config.parameters.yaml

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [AllowNull()]
        [object]
        $ResourceInput,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object]
        $Parameter
    )

    begin
    {
        # collect the command from index
        $commandData = GetDscCommandIndex -CommandName $MyInvocation.MyCommand.Name

        # build the input string for arguments
        $arguments = BuildDscInput -Command $commandData.Command -Operation $commandData.Operation -ResourceInput $ResourceInput -Parameter $Parameter
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
