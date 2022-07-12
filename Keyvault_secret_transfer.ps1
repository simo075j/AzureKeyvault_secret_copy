# This ps1 script can be used to move secrets across different keyvaults in different resource groups and subscriptions

$originVault = "<OriginKeyvaultName>"   # name of key vault resource
$originSubscriptionId = "<SubscriptionId>" # Subscription id of $originVault
$destinationVault = "<DestinationKeyvaultName>" # name of destination key vault resource

Write-Host "Setting origin subscription to: $($originSubscriptionId)..."
az account set -s $originSubscriptionId

Write-Host "Listing all origin secrets from vault: $($originVault)"
$originSecretKeys = az keyvault secret list --vault-name $originVault  -o json --query "[].name"  | ConvertFrom-Json

$originSecretKeys | ForEach-Object {
    $secretName = $_
    Write-Host " - Getting '$($secretName)' from origin, and setting in destination..."
    az keyvault secret set --name $secretName --vault-name $destinationVault -o none --value(az keyvault secret show --name $secretName --vault-name $originVault -o json --query "value")
} 

Write-Host "Finished."
