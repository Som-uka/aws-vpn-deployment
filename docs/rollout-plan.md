# Rollout Plan

A VPN is only useful once it reliably reaches everyone who needs it. The rollout was sequenced to de-risk a mixed-OS, mixed-MDM fleet.

## Phases
1. **Finalise and hash-pin both client scripts** (Windows PowerShell, macOS shell). Pin each installer to a known SHA256 so a tampered download is rejected.
2. **Pilot** on one physical machine per OS. Confirm install, profile delivery, connect, and private resolution end to end.
3. **Windows fleet** via the corporate MDM as a device script run as SYSTEM.
4. **macOS fleet** handed to the partner-managed MDM channel (see private-dns-design notes on tenant split).
5. **Explicit non-access group.** Build a directory group for users who should *not* have VPN access, making the access boundary deliberate rather than implicit.
6. **Connectivity test broadcast.** Ask all target users to connect and confirm; track responses before removing any legacy access path.

## Why this order
The legacy public access path is only removed after the VPN is proven for the full user base. Cutting access before confirming reachability is how you cause a self-inflicted outage.
