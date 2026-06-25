<#
.SYNOPSIS
    Verifies VPN connectivity to an internal resource over its private path.

.DESCRIPTION
    Run after connecting to the VPN. Confirms the internal hostname resolves
    to a private IP (proving private DNS is working) and that the target port
    is reachable through the tunnel.
#>

param(
    [string]$InternalHostname = "<internal-hostname>",
    [int]$Port = 443
)

Write-Output "Resolving $InternalHostname ..."
$resolved = Resolve-DnsName -Name $InternalHostname -ErrorAction SilentlyContinue
if (-not $resolved) {
    Write-Warning "DNS did not resolve. Private hosted zone or VPN DNS may not be active."
} else {
    $resolved | Select-Object Name, IPAddress | Format-Table -AutoSize
}

Write-Output "Testing TCP $Port to $InternalHostname through the tunnel..."
$test = Test-NetConnection -ComputerName $InternalHostname -Port $Port
if ($test.TcpTestSucceeded) {
    Write-Output "SUCCESS: reachable over the private path."
} else {
    Write-Warning "FAILED: not reachable. Check VPN connection and security group source rules."
}
