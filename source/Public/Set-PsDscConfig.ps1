function Set-PsDscConfig
{
  <#
  .SYNOPSIS
    Invokes the config set operation for DSC version 3 command-line utility.

  .DESCRIPTION
    The function Set-PsDscConfig invokes the config set operation on Desired State Configuration version 3 executable 'dsc.exe'.

  .PARAMETER Inputs
    The input to provide. Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

  .PARAMETER Parameter
    The parameter to provide. Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

  .EXAMPLE
    PS C:\> $configDoc = @{
      '$schema' = 'https://aka.ms/dsc/schemas/v3/bundled/config/document.json'
      resources = @(
        @{
          name = 'Echo 1'
          type = 'Microsoft.DSC.Debug/Echo'
          properties = @{
            output = 'hello'
          }
        },
        @{
          name = 'Echo 2'
          type = 'Microsoft.DSC.Debug/Echo'
          properties = @{
            output = 'world'
          }
        }
      )
    }

    PS C:\> Set-PsDscConfig -Inputs $configDoc

    This example retrieves the DSC configuration with the specified inputs using a hashtable.

  .NOTES
    For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
  #>
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
  param
  (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.Object]
    $Inputs,

    [Parameter()]
    [AllowNull()]
    [System.String]
    $Parameter
  )

  $inputParameter = Resolve-DscInput -Inputs $Inputs

  $processArgument = Confirm-DscConfigInput -Inputs $inputParameter -Parameter $Parameter -Operation 'set'

  $process = Get-ProcessObject -Argument $processArgument

  if ($PSCmdlet.ShouldProcess("$Inputs" , "Set"))
  {
    $result = Get-ProcessResult -Process $process
  }

  return $result
}
