<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>

[CmdletBinding()]
[Alias()]
[OutputType([int])]
Param
(

    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
        Position = 0)]
    $OrganizationName,

    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
        Position = 1)]
    $WorkSpaceName,

    #Token
	[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, 
	Position=2)]
	$Token

)

Begin {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution started: Getting Variables from Workspace"

    $GET= @{
        Uri         = "https://app.terraform.io/api/v2/vars?filter%5Borganization%5D%5Bname%5D=$OrganizationName&filter%5Bworkspace%5D%5Bname%5D=$WorkSpaceName"
        Headers     = @{"Authorization" = "Bearer $Token" }
        ContentType = 'application/vnd.api+json'
        Method      = 'GET'
        ErrorAction = 'stop'
    }
    
}
Process {
    $Result = (Invoke-RestMethod @GET).data
    Write-Host $Result.id
    ForEach($Variable in $Result.id)
    {
        Write-Host "$($MyInvocation.MyCommand.Name): Updating $($Variable.Key) variable to Terraform Enterprise Workspace (Name:$WorkSpaceName)"
    }
}
End {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete"

}
