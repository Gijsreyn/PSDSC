$Script:IsPowerShellCore = $PSVersionTable.PSEdition -eq 'Core'

if ($Script:IsPowerShellCore)
{
    Import-Module -Name 'PSDesiredStateConfiguration' -MinimumVersion 2.0.7 -Prefix 'Pwsh' -ErrorAction SilentlyContinue
}
