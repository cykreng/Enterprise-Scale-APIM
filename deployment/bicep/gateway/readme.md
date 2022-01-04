# Stand-alone Deployment 
These steps are for deploying an Azure Application Gateway standalone, and not a part of the overall Enterprise Scale APIM solution.

## Prequisites
1. A custom domain name (e.g. api.my-custom-domain.com)
1. A pfx certificate (e.g. api.my-custom-domain.com.pfx)
1. An Azure KeyVault
1. An Azure Virtual Network with a subnet for Application Gateway
1. An Azure API Management with Custom Domains (e.g. api-internal.my-custom-domain.com)

## Steps
1. cd ./deployment/bicep/gateway/tests
1. Update the appgw.test.bicep with your appropriate values
1. Copy certificate to be used to ~/deployment/bicep/gateway/certs and rename it to appgw.pfx
1. az deployment group create --name gw --resource-group rg-apim-example-prod-001 --template-file=appgw.test.bicep
