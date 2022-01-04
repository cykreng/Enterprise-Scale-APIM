param keyVaultName            string
param location                string
//param objectId                string
//param tenantId                string
param appGatewayFQDN          string
@secure()
param certPassword            string  

var secretName = replace(appGatewayFQDN,'.', '-')
var certData   = loadFileAsBase64('./appgw.pfx')

/*
resource accessPolicyGrant 'Microsoft.KeyVault/vaults/accessPolicies@2019-09-01' = {
  name: '${keyVaultName}/add'
  properties: {
    accessPolicies: [
      {
        objectId: objectId
        tenantId: tenantId
        permissions: {
          secrets: [ 
            'get'
            'list' 
          ]
        }                  
      }
    ]
  }
}
*/

resource appGatewayCertificate 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: '${secretName}-certificatte'
  location: location 
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '2.0.0'
    arguments: '-Name ${secretName} -VaultName ${keyVaultName} -CertificateString ${certData} -CertificatePassword ${certPassword}'
    scriptContent:'Import-AzKeyVaultCertificate -Name $args[0] -VaultName $args[1] -CertificateString $args[2] -Password $args[3]'
    retentionInterval: 'P1D'
  }
}

resource keyVaultCertificate 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' existing = {
  name: '${keyVaultName}/${secretName}'
}

output secretUri string = keyVaultCertificate.properties.secretUriWithVersion
