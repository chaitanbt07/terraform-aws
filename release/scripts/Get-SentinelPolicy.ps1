[CmdletBinding()]
[Alias()]
[OutputType([int])]
Param
(

    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true,
        Position = 0)]
    $OrganizationName,
	
    #Token
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, 
        Position = 1)]
    $Token

)

Begin {


    Write-Host "$($MyInvocation.MyCommand.Name): Script execution started"
    
}

Process {
    New-Item ./TFE_POLICYID_GET.txt -ItemType file
    Write-Host "Getting TFE Policies..."
    try {
        $Get     = @{
                Uri         = "https://app.terraform.io/api/v2/organizations/$OrganizationName/policies"
                Headers     = @{"Authorization" = "Bearer $Token" }
                ContentType = 'application/vnd.api+json'
                Method      = 'Get'
                ErrorAction = 'stop'
            }

        Write-Host "Get: $Get"
        $Result = (Invoke-RestMethod @Get).data
        Write-Host "Result: $Result"

        Write-Output "$(Result.attributes.name)=$($Result.id)" |out-file -Append ./TFE_POLICYID_GET.txt
    }

    catch {
            $ErrorID = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.status
            $Message = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.detail
            $Exception = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.title

            Write-Error -Message $Message

        }
}

End {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete."
}