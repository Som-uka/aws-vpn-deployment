<#
.SYNOPSIS
    Deploys the AWS VPN Client to a Windows machine via MDM.

.DESCRIPTION
    Downloads the approved AWS VPN Client installer, verifies it against a
    known-good SHA256 hash before executing (rejecting any tampered or
    corrupted download), installs silently, and drops the managed connection
    profile into place.

    Intended to be pushed as a device script from an MDM platform (e.g. Intune)
    and run as SYSTEM.

.NOTES
    The hash and download URL below are placeholders. In a real deployment
    these are pinned to the specific approved client version.
#>

$ErrorActionPreference = "Stop"

$InstallerUrl  = "<approved-aws-vpn-client-installer-url>"
$ExpectedHash  = "<sha256-of-approved-installer>"   # uppercase hex
$InstallerPath = "$env:TEMP\aws-vpn-client-setup.msi"
$ProfileSource = "<managed-connection-profile-path>"
$ProfileDest   = "$env:ProgramData\Amazon\AWS VPN Client\ConfigurationFiles\summit.ovpn"

Write-Output "Downloading AWS VPN Client installer..."
Invoke-WebRequest -Uri $InstallerUrl -OutFile $InstallerPath

Write-Output "Verifying installer integrity..."
$actual = (Get-FileHash -Path $InstallerPath -Algorithm SHA256).Hash
if ($actual -ne $ExpectedHash) {
    Write-Error "Hash mismatch. Expected $ExpectedHash, got $actual. Aborting."
    exit 1
}

Write-Output "Hash verified. Installing silently..."
Start-Process msiexec.exe -ArgumentList "/i `"$InstallerPath`" /quiet /norestart" -Wait

Write-Output "Deploying managed connection profile..."
New-Item -ItemType Directory -Force -Path (Split-Path $ProfileDest) | Out-Null
Copy-Item -Path $ProfileSource -Destination $ProfileDest -Force

Write-Output "AWS VPN Client deployment complete."
exit 0
