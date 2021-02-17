# AzureContainerEnumerator

This PowerShell script is used for checking your Azure environment and finding Azure Storage accounts and Containers in them who have public access configured.

Requirements:

* Azure PowerShell module 
* Azure account with sufficient permissions in your Azure environment

Instructions:

* Start Windows Terminal, Command Prompt or other application of your choice
* Execute AzStorageContainerEnumerator.ps1 script
* Login prompt will show up asking you to login with your Azure credentials to Azure tenant

Script will search through Azure subscriptions, find all Storage accounts and check if you have any Containers that are configured to allow Public access and will present the findings to you, so Containers can be double checked and confirmed if they should indeed be publicly accessible.
