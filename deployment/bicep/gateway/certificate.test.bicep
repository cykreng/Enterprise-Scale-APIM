var location =                      'southcentralus'
var appgwFqdn =                     'api.bjdcsa.cloud'
var apimRG =                        'DevSub01_BicepTest-RG'
var keyVaultName =                  'kv-bjdcsacloud'
var certPassword =                  'abc123'

module certificate 'certificate.bicep' = {
  name: 'certificate'
  scope: resourceGroup(apimRG)
  params: {
    appGatewayFQDN:                 appgwFqdn
    location:                       location
    keyVaultName:                   keyVaultName
    certPassword:                   certPassword
  }
}
