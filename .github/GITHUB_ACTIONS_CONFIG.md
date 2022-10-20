### Azure Configuration for GitHub  

The newly created GitHub repo uses GitHub Actions to deploy Azure resources and application code automatically. Your subscription is accessed using an Azure Service Principal. This is an identity created for use by applications, hosted services, and automated tools to access Azure resources. The following steps show how to [set up GitHub Actions to deploy Azure applications](https://github.com/Azure/actions-workflow-samples/blob/master/assets/create-secrets-for-GitHub-workflows.md)

1. Create an [Azure Service Principal](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli) with **contributor** permissions on the subscription. The subscription-level permission is needed because the deployment includes creation of the resource group itself.
 * Run the following [az cli](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest) command, either locally on your command line or on the Cloud Shell. 
   Replace {subscription-id} with the id of the subscription in GUID format. {service-principal-name} can be any alfanumeric string, e.g. GithubPrincipal
    ```bash  
       az ad sp create-for-rbac --name {service-principal-name} --role contributor --scopes /subscriptions/{subscription-id} --sdk-auth      
      ```
 * The command should output a JSON object similar to this:
 ```
      {
        "clientId": "<GUID>",
        "clientSecret": "<GUID>",
        "subscriptionId": "<GUID>",
        "tenantId": "<GUID>",
        "activeDirectoryEndpointUrl": "<URL>",
        "resourceManagerEndpointUrl": "<URL>",
        "activeDirectoryGraphResourceId": "<URL>",
        "sqlManagementEndpointUrl": "<URL>",
        "galleryEndpointUrl": "<URL>",
        "managementEndpointUrl": "<URL>"
      }
   ```
2. Store the output JSON as the value of a GitHub secret named 'AZURE_CREDENTIALS'
   + Under your repository name, click Settings. 
   + In the "Security" section of the sidebar, select Secrets. Make sure you select Actions in Secrets.
   + At the top of the page, click New repository secret
   + Provide the secret name as AZURE_CREDENTIALS
   + Add the output JSON as secret value
  
### Required Parameter Definitions 

3. The following  parameters are required.

| Property | Description | Valid Options | Default Value |
|----------|-------------|---------------|---------------|
| `Azure_Credentials` | The JSON that is provided when you create a service principal. | |


### Azure Portal Permissions Configuration

4. Verify your Azure Permissions ( You must have Contributor, Owner and User Access Administrator roles)
      
  * The AzureService Principal requires roleAssignment/write permission, so make sure  your Azure user account has Microsoft.Authorization/roleAssignments/write permissions, such as User Access Administrator or Owner and Contributor. More info can be found in the documentation for [Azure built-in roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles).

  + Go to your Subcription, look to the left hand side menu and select Access Control (IAM).

  + Select Role Assignments.

  + Type in the name of your Service Principal, check the access levels.

  + Since you just created it, the Service Principal will have Contributor Access.

  + In the Top Menu...Click "+Add", and select App Role Assignment from the drop down menu...

  + In the Role Serach Box.... type "User Access Administrator"

  + In the Details column, click "View" to review permissions to be assigned.

  + At the bottom of the page, click "Select Role"

  + Then click.."Next"

  + On th Menbers Page...click "+Select Members"

  + On the Select Members menu..type the name of the "Service Principal" in the select box (**Note:  ** This should be the name of your newly created Service Principal.)

  + At the bottom of the menu, click Select

  + Click Review and Assign....

  + Repeat this process and in the Role Serach Box.... type "Owner"


