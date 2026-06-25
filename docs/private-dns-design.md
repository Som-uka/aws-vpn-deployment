# Private DNS Design

## The problem a tunnel alone doesn't solve
A VPN tunnel gives a private network path, but if the client still resolves an internal hostname to its public IP, traffic leaves the private network anyway. Private DNS is what makes the tunnel actually used.

## Approach
A Route 53 private hosted zone, associated with the VPC, resolves internal hostnames to private IPs for VPN-connected clients. Public DNS is left untouched, so nothing changes for users not on the VPN until cutover.

## Per-machine override for phased migration
During a phased per-user migration, a single hosts-file entry can force one hostname down the private path for a specific user without changing public DNS for everyone. This lets users migrate individually, with public DNS updated only once everyone is moved.

## The mixed-MDM reality
A practical lesson worth recording: not every device is managed from the same place. In this rollout, Windows machines received scripts directly from the corporate MDM, but the Macs were enrolled in a partner-managed MDM tenant and had to be distributed through that channel instead. Identifying which devices reported to which tenant was a prerequisite to reaching the whole fleet. Enterprise deployments live or die on this kind of detail.
