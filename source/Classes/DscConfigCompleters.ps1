# class DscConfigCompleter : System.Management.Automation.IArgumentCompleter
# {
#     [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
#         [string] $CommandName,
#         [string] $ParameterName,
#         [string] $wordToComplete,
#         [System.Management.Automation.Language.CommandAst] $CommandAst,
#         [Collections.IDictionary] $fakeBoundParameters
#     )
#     {
#         $exe = ResolveDscExe -ErrorAction SilentlyContinue

#         $list = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()

#         if ($exe)
#         {
#             $resources = GetDscResourceDetail -Exclude @{kind = 'Group' } # don't include Group resources
#             foreach ($resource in $resources)
#             {
#                 $CompletionText = $resource
#                 $ListItemText = $resource
#                 $ResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
#                 $ToolTip = $resource

#                 $obj = [System.Management.Automation.CompletionResult]::new($CompletionText, $ListItemText, $ResultType, $Tooltip)
#                 $list.add($obj)
#             }

#             return $list
#         }
#         else
#         {
#             return $list
#         }
#     }
# }

# class DscConfigInputCompleter : System.Management.Automation.IArgumentCompleter
# {
#     [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
#         [string] $CommandName,
#         [string] $ParameterName,
#         [string] $wordToComplete,
#         [System.Management.Automation.Language.CommandAst] $CommandAst,
#         [Collections.IDictionary] $fakeBoundParameters
#     )
#     {
#         if ($fakeBoundParameters.ContainsKey('ResourceName') -or $fakeBoundParameters.ContainsKey('ResourceType'))
#         {
#             [array]$Resources = GetDscRequiredKey -BuildHashTable | Where-Object {
#                 $_.type -eq $fakeBoundParameters.ResourceName -or $_.type -eq $fakeBoundParameters.ResourceType
#             } | Select-Object -ExpandProperty resourceInput -Unique | Sort-Object
#         }
#         else
#         {
#             [array]$Resources = @()
#         }

#         $list = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()

#         foreach ($Resource in $Resources)
#         {
#             $CompletionText = $Resource
#             $ListItemText = $Resource
#             $ResultType = [System.Management.Automation.CompletionResultType]::ParameterValue

#             $ToolTip = '{0}' -f $fakeBoundParameters.ResourceName

#             $obj = [System.Management.Automation.CompletionResult]::new($CompletionText, $ListItemText, $ResultType, $Tooltip)
#             $list.add($obj)
#         }

#         return $list
#     }
# }
