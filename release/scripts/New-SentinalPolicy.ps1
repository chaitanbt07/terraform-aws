[CmdletBinding()]
[Alias()]
[OutputType([int])]
Param
(

    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
        Position = 0)]
    $OrganizationName,

    #Token
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, 
        Position = 1)]
    $Token

)

Begin {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution started"
    
    $Json = @{
        "data" = @{
            "type"="policies"
            "attributes"= @{
                "name"= "policy1"
                "enforce"= @{
                    [
                    @{
                    "path"="policy1.sentinel"
                    "mode"="hard-mandatory"
                    }
                    ]
                }
                
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
}

Process {
    try {
        $Result = (Invoke-RestMethod @Post).data
        Write-Output "TFE_POLICY_ID=$($Result.id)" |out-file ./TFE_POLICYID.txt
        Get-ChildItem
        Return $Result
    }
    catch {
        $ErrorID = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.status
        $Message = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.detail
        $Exception = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.title

        Write-Error -Exception $Exception -Message $Message -ErrorId $ErrorID
    }
    finally {
        If ($Result) {
            Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete"
        }
    }
}
End {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete."
}