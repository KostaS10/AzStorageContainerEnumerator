$ErrorActionPreference= 'silentlycontinue'
$containersarray = @()

Write-Output @"
==============================================
Azure Storage Accounts container scanner
	by Kosta S.
==============================================

Scanning your Azure Storage Accounts, finding public exposed containers

"@

try{    
	$subs = Get-AzSubscription
    $subsname = (Get-AzSubscription).Name
    $subscount = $subsname.count

    if($subscount -gt 1){
        Write-Output "INFO: Found $subscount subscriptions"
		Write-Output "SUBSCRIPTIONS: $subsname"
        }
    elseif($subscount -eq 1){
        Write-Output "INFO: Found $subscount subscription"
		Write-Output "SUBSCRIPTIONS: $subsname"
        }
	elseif($subscount -eq 0){
		Write-Output "INFO: $subscount subscriptions found"
		Write-Output "Make sure that the account that you are logged into your Azure environment has sufficient permissions"
		break
	}
} catch {
        "ERROR: Subscriptions could not be listed, make sure you are connected to your Azure environment using Connect-AzAccount"
		break
}



foreach($sub in $subs){
	
	Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext | Out-Null
	$subname = $sub.Name
	Write-Output "INFO: Finding Azure Storage Accounts in $subname"

	$storageaccs = Get-AzStorageAccount
	$storageaccsnames = (Get-AzStorageAccount).StorageAccountName
	$storageaccscount = $storageaccsnames.count

	Write-Output "INFO: Found $storageaccscount Storage Accounts in $subname"
	Write-Output "STORAGE ACCOUNTS: $storageaccsnames"
	
	Write-Output "INFO: Listing Containers with Public Access in $subname"

	foreach($storageacc in $storageaccs){

		$ctx = $storageacc.Context

		$containersarray += (Get-AzStorageContainer -Context $ctx | where {$_.PublicAccess -eq "Container"})

		}
	$publiccontainers = $containersarray | where {$_.Name}
	$publiccontainersuri = $publiccontainers.CloudBlobContainer.Uri.AbsoluteURI
		Write-Output "CONTAINERS: $publiccontainersuri"
	}

	Write-Output @"
==============================================

Listing Azure Storage Accounts and Containers that have Public access configured on them

"@

	$containers = $containersarray | where {$_.Name}
	$containersuri = $containers.CloudBlobContainer.Uri.AbsoluteURI
	foreach($containeruri in $containersuri){
		$split1 = $containeruri.Split("//")
		$stghostname = $split1[2]
		$containername = $split1[3]
		$split2 = $stghostname.Split(".")
		$stgname = $split2[0]
		
		[pscustomobject]@{
			StrorageName = $stgname
			ContainerName = $containername
			AccessLevel = "Public"
		}
	}


	



