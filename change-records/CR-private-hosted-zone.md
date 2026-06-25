# CR: Private Hosted Zone for Internal Resolution

| Field | Details |
|---|---|
| Change ID | CR-VPN-002 |
| Environment | Production |
| Risk Level | Low |
| Status | Complete |

## Description
Created a Route 53 private hosted zone associated with the VPC so VPN-connected clients resolve an internal hostname to its private IP, keeping traffic inside the network instead of routing over the public internet.

## Steps Performed
```bash
aws route53 create-hosted-zone --name <internal-domain> \
  --vpc VPCRegion=us-east-1,VPCId=<vpc-id> \
  --hosted-zone-config PrivateZone=true \
  --caller-reference $(date +%s)

aws route53 change-resource-record-sets --hosted-zone-id <zone-id> \
  --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{
    "Name":"<internal-hostname>","Type":"A","TTL":60,
    "ResourceRecords":[{"Value":"<private-ip>"}]}}]}'
```

## Post-Change Validation
- Resolution confirmed from a VPN-connected client (returns private IP)
- Confirmed public DNS unaffected (no public record created)

## Rollback Plan
Delete the A record, then the hosted zone.

## Outcome
Success. VPN clients resolve internal hostnames privately, TTL 60.
