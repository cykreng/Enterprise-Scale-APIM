var location =                      'southcentralus'
var appgwFqdn =                     'api.bjdcsa.cloud'
var apimRG =                        'DevSub01_BicepTest-RG'
var keyVaultName =                  'kv-bjdcsacloud'
var certPassword =                  'abc123'

var appGatewayIdentityId            = 'identity-bjdcsacloud'

resource appGatewayIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name:     appGatewayIdentityId
  location: location
}

module certificate '../modules/certificate.bicep' = {
  name: 'certificate'
  scope: resourceGroup(apimRG)
  params: {
    appGatewayFQDN:                 appgwFqdn
    location:                       location
    keyVaultName:                   keyVaultName
    certPassword:                   certPassword
    objectId:                       appGatewayIdentity.properties.principalId
    tenantId:                       appGatewayIdentity.properties.tenantId
    resourceId:                     appGatewayIdentity.id
  }
}


