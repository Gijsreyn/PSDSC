function BuildDscInput
{
    <#
    .SYNOPSIS
        Build the Desired State Configuration input string.

    .DESCRIPTION
        The function BuildDscInput builds the argument input string to pass to 'dsc.exe'.

    .PARAMETER Command
        The sub command to run e.g. config

    .PARAMETER Operation
        The operation to run e.g. Set

    .PARAMETER ResourceName
        The resource name to execute.

    .PARAMETER ResourceInput
        The resource input to provide. Supports JSON, YAML path and PowerShell hash table.

    .PARAMETER Parameter
        Optionally, the parameter input to provide.

    .EXAMPLE
        PS C:\> BuildDscInput -Arguments config -Operation get -ResourceInput myconfig.dsc.config.yaml

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("config", "resource")]
        [System.String]
        $Command,

        [Parameter(Mandatory = $true)]
        [ValidateSet('list', 'get', 'set', 'test', 'delete', 'export')]
        [System.String]
        $Operation,

        [Parameter(Mandatory = $false)]
        [Alias('Name')]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object]
        $ResourceInput,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object]
        $Parameter
    )

    # string to build
    $sb = [System.Text.StringBuilder]::new($Command)

    if ($Command -eq 'config' -and $Operation -in @('list', 'delete'))
    {
        # TODO: helpful documentation to use _exist for set operation
        Throw "Operation not valid when running 'dsc config'. Please use different combination."
    }

    switch ($Command)
    {
        'config'
        {
            # start validating parameters first
            $paramValue = ConfirmDscInput -Command $Command -ParameterInput $Parameter

            if ($paramValue)
            {
                Write-Debug -Message "Appending '$ParamValue'"
                $sb.Append(" $paramValue") | Out-Null
            }

            $sb.Append(" $Operation") | Out-Null

            $inputValue = ConfirmDscInput -Command $Command -ResourceInput $ResourceInput

            if ($inputValue)
            {
                $sb.Append(" $inputValue") | Out-Null
            }
        }
        'resource'
        {
            # operation comes first
            $sb.Append(" $Operation") | Out-Null

            $inputValue = ConfirmDscInput -Command $Command -ResourceInput $ResourceInput

            if ($Operation -ne 'List' -and ([string]::IsNullOrEmpty($ResourceName)))
            {
                Throw ("You are attempting to run 'dsc resource' using operation '{0}' without resource name. Please specify the resource name using -ResourceName" -f $Operation)
            }

            if ($Operation -eq 'List')
            {
                $inputValue = $null

                $string = " --adapter $ResourceName"
                # TODO: validate the resource name should be an adapter
            }

            if ($Operation -in @('get', 'set', 'test', 'delete', 'export'))
            {
                $string = " --resource $ResourceName"
            }

            $sb.Append($string) | Out-Null

            if ($inputValue)
            {
                $sb.Append(" $inputValue") | Out-Null
            }
        }
        Default
        {
        }
    }

    return $sb.ToString()
}
