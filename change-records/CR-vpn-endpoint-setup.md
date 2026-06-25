# CR: Client VPN Endpoint Setup

| Field | Details |
|---|---|
| Change ID | CR-VPN-001 |
| Environment | Production |
| Risk Level | Medium |
| Status | Complete |

## Description
Stood up an AWS Client VPN endpoint as the controlled private access path into the VPC, with certificate-based mutual auth plus federated identity, associated with the target subnets, and authorization scoped to an identity-provider security group.

## Steps Performed
```bash
aws ec2 create-client-vpn-endpoint \
  --client-cidr-block <vpn-client-cidr> \
  --server-certificate-arn <acm-cert-arn> \
  --authentication-options Type=federated-authentication,FederatedAuthentication={SAMLProviderArn=<saml-arn>} \
  --connection-log-options Enabled=true,CloudwatchLogGroup=<log-group>

aws ec2 associate-client-vpn-target-network \
  --client-vpn-endpoint-id <endpoint-id> --subnet-id <private-subnet>
```

## Post-Change Validation
- Test client connected and authenticated via the IdP
- Connection logs confirmed flowing to the CloudWatch log group

## Rollback Plan
Disassociate target networks and delete the endpoint.

## Outcome
Success. Private access path established; basis for removing public exposure later.
