param keyVaultName            string
param location                string
param objectId                string
param tenantId                string
param resourceId              string
param appGatewayFQDN          string
@secure()
param certPassword            string  

var secretName = replace(appGatewayFQDN,'.', '')
var certData   = loadFileAsBase64('./appgw.pfx')

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
          certificates: [
            'import'
          ]
        }                  
      }
    ]
  }
}


resource appGatewayCertificate 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: '${secretName}-certificate'
  dependsOn: [
    accessPolicyGrant
  ]
  location: location 
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '6.6'
    scriptContent:'Login-AzAccount -Identity;$ss = Convertto-SecureString -String ${certPassword} -AsPlainText -Force; Import-AzKeyVaultCertificate -Name ${secretName} -VaultName ${keyVaultName} -CertificateString ${certData} -Password $ss'
    retentionInterval: 'P1D'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId}': {}
    }
  }
}

resource keyVaultCertificate 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' existing = {
  name: '${keyVaultName}/${secretName}'
  dependsOn: [
    appGatewayCertificate
  ]
}

output secretUri string = keyVaultCertificate.properties.secretUriWithVersion

