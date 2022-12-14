

function Install-ModuleForCurrentUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $ModuleRoot
    )
    $ModuleRoot = Convert-Path $ModuleRoot
    $psModulePath = Get-PSModulePathForCurrentUser

    Assert-PSModuleProjectFiles $ModuleRoot
    # Update-PSModuleProjectFiles $ModuleRoot -Force:$Force

    $manifestPath = Convert-Path $ModuleRoot\*.psd1

    $moduleName = $manifestPath | Split-Path -LeafBase
    $version = [version] (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')

    "Using '$psModulePath' as base path..."
    $destPath = Join-Path $psModulePath $moduleName $version

    "Creating directory at '$destPath'..."
    $null = New-Item -Path $destPath -ItemType 'Directory' -Force -ErrorAction 'Ignore'

    "Copying items from '$ModuleRoot' to '$destPath'..."
    $null = Copy-Item -Path "$ModuleRoot\*" -Destination $destPath -Recurse -Force
}
