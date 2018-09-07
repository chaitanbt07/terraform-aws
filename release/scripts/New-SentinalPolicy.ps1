[CmdletBinding()]
[Alias()]
[OutputType([int])]
Param
(

    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true,
        Position = 0)]
    $OrganizationName,
	
	#Path
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, 
        Position = 1)]
    $Path,

    #Token
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, 
        Position = 2)]
    $Token

)

Begin {


    Write-Host "$($MyInvocation.MyCommand.Name): Script execution started"
    
}

Process {

	$Policies = @(Get-ChildItem $Path)
	New-Item ./TFE_POLICYID.txt -ItemType file
	
	foreach ($Policy in $Policies) {

	try {

	$Json = @{
        "data" = @{
            "type"="policies"
            "attributes"= @{
                "name"= ($Policy).basename
                "enforce"= @(
                    @{
                    "path"=$Policy.name
                    "mode"="soft-mandatory"
                    }
                    )
            }
        }
    } | ConvertTo-Json -Depth 5

    $Json

    $Post = @{
        Uri = "https://app.terraform.io/api/v2/organizations/$OrganizationName/policies"
        Headers     = @{"Authorization" = "Bearer $Token" }
        ContentType = 'application/vnd.api+json'
        Method      = 'Post'
        Body        = $Json
        ErrorAction = 'stop'
    }
	
    
        $Result = (Invoke-RestMethod @Post).data
        Write-Output "$($Policy.name)=$($Result.id)" |out-file -Append ./TFE_POLICYID.txt
        Get-ChildItem
        Return $Result
    }
    catch {
        $ErrorID = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.status
        $Message = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.detail
        $Exception = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.title

        Write-Error -Exception "Exception" $Exception -Message "Message" $Message -ErrorId "Error" $ErrorID
    }
    
}
}
End {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete."
}