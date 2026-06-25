# CR: Identity-Group Access Enforcement

| Field | Details |
|---|---|
| Change ID | CR-VPN-003 |
| Environment | Production |
| Risk Level | Medium |
| Status | Complete |

## Description
Moved VPN authorization from an all-users rule to a specific identity-provider security group, so only members of the VPN access group can connect. The broad all-users rule was removed only after the group rule was confirmed working and all required users were in the group.

## Steps Performed
```bash
# Add the group-scoped rule first
aws ec2 authorize-client-vpn-ingress \
  --client-vpn-endpoint-id <endpoint-id> \
  --target-network-cidr 0.0.0.0/0 \
  --access-group-id <idp-group-id> --authorize-all-groups false

# Only after validation: remove the all-users rule
aws ec2 revoke-client-vpn-ingress \
  --client-vpn-endpoint-id <endpoint-id> \
  --target-network-cidr 0.0.0.0/0 --revoke-all-groups
```

## Post-Change Validation
- Member of the access group: connects successfully
- Non-member: correctly denied
- Sequencing ensured no active user was locked out mid-change

## Rollback Plan
Re-add the all-users authorization rule.

## Outcome
Success. Access is now governed by directory group membership.
