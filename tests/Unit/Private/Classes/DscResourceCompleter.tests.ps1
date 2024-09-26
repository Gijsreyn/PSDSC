# Describe 'DscResourceInputCompleter' {
#     It 'should return completion results based on ResourceName' {
#         # Mock GetDscRequiredKey to return resource inputs
#         Mock -CommandName GetDscRequiredKey -MockWith {
#             @(
#                 [pscustomobject]@{ type = 'ResourceType1'; resourceInput = 'Input1' },
#                 [pscustomobject]@{ type = 'ResourceType1'; resourceInput = 'Input2' }
#             )
#         }

#         $completer = [DscResourceInputCompleter]::new()
#         $fakeBoundParameters = @{ 'ResourceName' = 'ResourceType1' }
#         $results = $completer.CompleteArgument('', '', '', $null, $fakeBoundParameters)

#         $results.Count | Should -Be 2
#         $results[0].CompletionText | Should -Be "'Input1'"
#         $results[1].CompletionText | Should -Be "'Input2'"
#     }

#     It 'should return an empty list when ResourceName is not provided' {
#         $completer = [DscResourceInputCompleter]::new()
#         $fakeBoundParameters = @{}
#         $results = $completer.CompleteArgument('', '', '', $null, $fakeBoundParameters)

#         $results.Count | Should -Be 0
#     }
# }
