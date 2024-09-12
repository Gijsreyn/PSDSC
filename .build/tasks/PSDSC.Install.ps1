param
(
)

task PSDSC.Install {
    Write-Verbose "Installing 'dsc.exe' from Github" -Verbose
    Install-DscCLI -Verbose
}
