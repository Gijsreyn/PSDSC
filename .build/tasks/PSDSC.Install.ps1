param
(
)

function Add-PathToEnvironmentVariable
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Machine", "User", "Process")]
        [string]$Target
    )

    Write-Output $Path
    # Validate the target
    $targetEnum = [System.EnvironmentVariableTarget]::Machine
    switch ($Target)
    {
        "Machine"
        {
            $targetEnum = [System.EnvironmentVariableTarget]::Machine
        }
        "User"
        {
            $targetEnum = [System.EnvironmentVariableTarget]::User
        }
        "Process"
        {
            $targetEnum = [System.EnvironmentVariableTarget]::Process
        }
    }

    # Get the current PATH environment variable for the specified target
    $currentPath = [System.Environment]::GetEnvironmentVariable('PATH', $targetEnum)

    $paths = $currentPath.Split(";")

    # Check if the specified path is already in the PATH environment variable
    if (-not ($Path -in $Paths))
    {
        # Add the path to the PATH environment variable
        $newPath = "$currentPath;$Path"
        [System.Environment]::SetEnvironmentVariable('PATH', $newPath, $targetEnum)
        Write-Output "Path added to $Target PATH environment variable."
    }
    else
    {
        Write-Output "Path already exists in $Target PATH environment variable."
    }
}

task PSDSC.Windows.Install {
    Write-Build Yellow "Installing 'dsc.exe' from Github"

    if (-not $IsWindows)
    {
        throw "This function is only supported for Windows systems."
    }

    $base = 'https://api.github.com/repos/PowerShell/DSC/releases/latest'

    $releases = Invoke-RestMethod -Uri $base

    $fileName = 'DSC-3.0.0-x86_64-pc-windows-msvc.zip'
    # get latest asset to be downloaded
    $asset = $releases.assets | Where-Object -Property Name -Like $fileName

    # download the installer
    $tmpdir = [System.IO.Path]::GetTempPath()
    $fileName = $asset.name
    $installerPath = [System.IO.Path]::Combine($tmpDir, $fileName)
        (New-Object Net.WebClient).DownloadFileAsync($asset.browser_download_url, $installerPath)
    Write-Verbose "Downloading $($asset.browser_download_url) to location $installerPath"
    do
    {
        $PercentComplete = [math]::Round((Get-Item $installerPath).Length / $asset.size * 100)
        Write-Progress -Activity 'Downloading DSC' -PercentComplete $PercentComplete
        start-sleep 1
    } while ((Get-Item $installerPath).Length -lt $asset.size)

    $exePath = Join-path $env:ProgramFiles 'dsc'

    Write-Build Yellow "Expanding archive: $installerPath to $exePath"
    $null = Expand-Archive -LiteralPath $installerPath -DestinationPath $exePath -Force

    Add-PathToEnvironmentVariable -Path $exePath -Target Machine
    Add-PathToEnvironmentVariable -Path $exePath -Target Process

    & dsc --version
}
