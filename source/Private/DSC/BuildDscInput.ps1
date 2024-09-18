function BuildDscInput
{
    <#
    .SYNOPSIS
        Build the Desired State Configuration input string.

    .DESCRIPTION
        The function BuildDscInput builds the argument input string to pass to 'dsc.exe'.

    .PARAMETER SubCommand
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
        PS C:\> BuildDscInput -SubCommand config -Operation get -ResourceInput myconfig.dsc.config.yaml

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
        $SubCommand,

        [Parameter(Mandatory = $true)]
        [ValidateSet('List', 'Get', 'Set', 'Test', 'Delete', 'Export')]
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

    begin
    {
        function _validateDscInput ($ResourceInput, $SubCommand)
        {
            $stringIn = $null
            $converted = $false

            if (-not [string]::IsNullOrEmpty($ResourceInput))
            {
                $type = $ResourceInput.GetType().Name

                if ($type -eq 'HashTable')
                {
                    $data = ($ResourceInput | ConvertTo-Json -Depth 10 -Compress | ConvertTo-Json) -replace "\\\\", "\" | Out-String
                    $converted = $true
                }

                try
                {
                    if ($ResourceInput | ConvertFrom-Json -ErrorAction SilentlyContinue)
                    {
                        # workaround same as hashtable
                        $data = ($ResourceInput | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress) -replace "\\\\", "\" | ConvertTo-Json
                        $converted = $true
                    }
                }
                catch
                {
                    Write-Debug -Message ("Tried converting [{0}], but failed. Make sure if you are passing in JSON data, it is valid." -f ($ResourceInput | ConvertTo-Json -Depth 10 -Compress))
                }

                if ((Get-Item $ResourceInput -ErrorAction SilentlyContinue).Extension -in ('.json', '.yml', '.yaml') -and (Test-Path $ResourceInput -ErrorAction SilentlyContinue))
                {
                    $data = $ResourceInput
                }

                if ($converted -and $SubCommand -eq 'resource')
                {
                    $stringIn = " --input $data"
                }
                elseif ($converted -and $SubCommand -eq 'config')
                {
                    $stringIn = " --document $data"
                }
                elseif ($data)
                {
                    $stringIn = " --path $data"
                }
            }
            else
            {
                if ($SubCommand -eq 'config')
                {
                    Throw "You are attempting to run 'dsc config' without resource input. Please provide input by adding -ResourceInput parameter."
                }
            }

            if ($stringIn)
            {
                Write-Debug -Message "Appending input data: $stringIn"
                $null = $builder.Append($stringIn)
            }

        }

        function _validateDscInputParameter ($Parameter)
        {
            $stringIn = $null
            # check if parameter requires to be adding in front
            if (-not [string]::IsNullOrEmpty($Parameter))
            {
                # add parameter file if extension is in list
                if ((Get-Item $Parameter -ErrorAction SilentlyContinue).Extension -in ('.json', '.yml', '.yaml') -and (Test-Path $Parameter))
                {
                    $stringIn = " --parameters-file $Parameter"
                }
                else
                {
                    $type = $parameter.GetType().Name

                    if ($type -eq 'HashTable')
                    {
                        $parameters = ($Parameter | ConvertTo-Json -Depth 10 -Compress | ConvertTo-Json) -replace "\\\\", "\" | Out-String
                    }

                    try
                    {
                        if ($Parameter | ConvertFrom-Json -ErrorAction SilentlyContinue)
                        {

                            $parameters = ($Parameter | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress) -replace "\\\\", "\" | ConvertTo-Json   # workaround same as hashtable
                        }
                    }
                    catch
                    {
                        Write-Debug -Message ("Tried converting [{0}], but failed. Make sure if you are passing in JSON parameter data, it is valid." -f ($parameter | ConvertTo-Json -Depth 10 -Compress))
                    }

                    if ($parameters)
                    {
                        $stringIn = (" --parameters $parameters" -replace "`r`n", "")
                    }
                }
            }

            if ($stringIn)
            {
                Write-Debug -Message "Appending parameter data: $stringIn"
                $null = $builder.Append($stringIn)
            }
        }
    }

    process
    {
        $builder = [System.Text.StringBuilder]::new($SubCommand)

        $Operation = $Operation.ToLower()

        if ($SubCommand.StartsWith("config"))
        {
            # in the config, it can happen that parameter needs to be added before operation
            _validateDscInputParameter -Parameter $Parameter

            if ($Operation -eq 'List')
            {
                Throw ("This '{{0}}' operation is not supported when calling 'dsc config'" -f $Operation)
            }

            if ($Operation -eq 'Delete')
            {
                Throw ("This '{{0}}' operation is not supported when calling 'dsc config'. You can use the '_exist' property in combination with the 'Set' operation." -f $Operation)
            }

            # append operation
            $builder.Append(" $Operation") | Out-Null

            # validate the input
            _validateDscInput -ResourceInput $ResourceInput -SubCommand $SubCommand
        }

        if ($SubCommand.StartsWith('resource'))
        {
            # start adding operation
            $builder.Append(" $Operation") | Out-Null

            if ($Operation -ne 'List' -and ([string]::IsNullOrEmpty($ResourceName)))
            {
                Throw ("You are attempting to run 'dsc resource' using operation '{1}' without resource name. Please specify the resource name using -ResourceName" -f $Operation)
            }

            if ($Operation -eq 'List')
            {
                $builder.Append(" --adapter $ResourceName") | Out-Null # if not, dsc will throw error anyway that it is not adapter
                $ResourceInput = $null
            }
            else
            {
                # add resource
                $builder.Append(" --resource $ResourceName") | Out-Null
            }

            if ($Operation -eq 'Export')
            {
                # export does not need input
                $ResourceInput = $null
            }

            # go validate what input we are getting
            _validateDscInput -ResourceInput $ResourceInput -SubCommand $SubCommand
        }

        return ($builder.ToString())

        # if ($SubCommand.StartsWith("resource"))
        # {
        #     Write-Debug -Message "Adding '$ResourceName' argument"
        #     $StringBuilder.Append(" --resource $ResourceName") | Out-Null
        # }
    }

    end
    {

    }
}
