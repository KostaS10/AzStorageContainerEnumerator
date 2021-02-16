# AzureContainerEnumerator

This PowerShell script is used for checking your Azure environment and finding Azure Storage accounts and Containers in them who have public access configured.

Requirements:

* Azure PowerShell module 
* Connect to your Azure environment with Connect-AzAccount cmdlet with an account with sufficient permissions

Instructions:

Once logged into your Azure environment, just ran the script provided and it will present a list of Storage Accounts and it's Containers that have public access configured on them, so you can double check if that is an intended configuration.
