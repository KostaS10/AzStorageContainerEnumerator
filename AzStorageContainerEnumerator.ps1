$ErrorActionPreference= 'silentlycontinue'
$ProgressPreference = "SilentlyContinue"
$containersarray = @()

Write-Output @"
==============================================
AzStorageContainerEnumerator
	by Kosta S.
==============================================
Scanning your Azure Storage Accounts, finding public exposed containers
"@
try {
    $account = Connect-AzAccount
}catch{
    "ERROR: Make sure you are connected to your Azure environment with Connect-AzAccount"
	break
}
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

		$containersarray += (Get-AzStorageContainer -Context $ctx | where {$_.PublicAccess -eq "Container" -or $_.PublicAccess -eq "Blob"})

		}
	$publiccontainers = $containersarray | where {$_.Name}
	$publiccontainersuri = $publiccontainers.CloudBlobContainer.Uri.AbsoluteURI
		Write-Output "CONTAINERS: $publiccontainersuri"
	}

	Write-Output @"
==============================================
INFO: Listing Azure Storage Accounts and Containers that have Public access configured on them
"@


	$containers = $containersarray | where {$_.Name}
	if($container.Count -eq 0){
		Write-Output "INFO: No Azure Storage accounts and Containers found with Public access configured"
	}else{
	foreach($container in $containers){
		$containeruri = $container.CloudBlobContainer.Uri.AbsoluteURI
		$containeraccess = $container.PublicAccess
		$split1 = $containeruri.Split("//")
		$stghostname = $split1[2]
		$containername = $split1[3]
		$split2 = $stghostname.Split(".")
		$stgname = $split2[0]
		
		[pscustomobject]@{
			StrorageName = $stgname
			ContainerName = $containername
			AccessLevel = $containeraccess
		}
	}
}
