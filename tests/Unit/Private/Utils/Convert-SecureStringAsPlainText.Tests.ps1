BeforeAll {
    $script:moduleName = 'PSDSC'

    if (-not (Get-Module -Name $script:moduleName -ListAvailable))
    {
        & "$PSScriptRoot/../../../../build.ps1" -Tasks 'noop' 2>&1 4>&1 5>&1 6>&1 > $null
    }

    Import-Module -Name $script:moduleName -Force -ErrorAction 'Stop'

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName
}

AfterAll {
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force
}

Describe 'Convert-SecureStringAsPlainText' {
    Context 'When converting a secure string to plain text' {
        BeforeAll {
            # Create a test secure string
            $testPlainText = 'P@ssw0rd'
            $testSecureString = ConvertTo-SecureString -String $testPlainText -AsPlainText -Force
        }

        It 'Should convert the secure string correctly' {
            InModuleScope -ScriptBlock {
                $result = Convert-SecureStringAsPlainText -SecureString $SecureString
                $result | Should -Be $ExpectedPlainText
            } -Parameters @{
                SecureString      = $testSecureString
                ExpectedPlainText = $testPlainText
            }
        }

        It 'Should handle empty secure string' {
            InModuleScope -ScriptBlock {
                $emptySecureString = New-Object -TypeName System.Security.SecureString
                $result = Convert-SecureStringAsPlainText -SecureString $emptySecureString
                $result | Should -Be ''
            }
        }
    }
}
