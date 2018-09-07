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
	
    foreach ($Policy in $Policies.name) {

        try {

            $Json = @{
                "data" = @{
                    "type"       = "policies"
                    "attributes" = @{
                        "name"    = $Policy.Replace(".sentinel", "")
                        "enforce" = @(
                            @{
                                "path" = $Policy
                                "mode" = "soft-mandatory"
                            }
                        )
                    }
                }
            } | ConvertTo-Json -Depth 5

            $Json

            $Post = @{
                Uri         = "https://app.terraform.io/api/v2/organizations/$OrganizationName/policies"
                Headers     = @{"Authorization" = "Bearer $Token" }
                ContentType = 'application/vnd.api+json'
                Method      = 'Post'
                Body        = $Json
                ErrorAction = 'stop'
            }
	
    
            $Result = (Invoke-RestMethod @Post).data
            Write-Output "$Policy.Replace(".sentinel", "")=$($Result.id)" |out-file -Append ./TFE_POLICYID.txt
            Get-ChildItem
            Return $Result
        }
        catch {
            $ErrorID = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.status
            $Message = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.detail
            $Exception = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.title

            Write-Error -Exception $Exception -Message $Message -ErrorId $ErrorID
        }
	
        If ($ErrorID -eq 422) {
            Write-Host "$($MyInvocation.MyCommand.Name): $Message. Getting Policy ID for existing policy $Policy.Replace(".sentinel", "")."

            try {
                $Get = @{

                    Uri         = "https://app.terraform.io/api/v2/organizations/$OrganizationName/policies"
                    Headers     = @{"Authorization" = "Bearer $Token" }
                    ContentType = 'application/vnd.api+json'
                    Method      = 'Get'
                    ErrorAction = 'stop'
                }

                $Existing = (Invoke-RestMethod @Get).data

                Write-Output "$Policy.Replace(".sentinel", "")=$($Existing.id)" |out-file -Append ./TFE_POLICYID.txt 
                Get-ChildItem
                Return $Existing
            }
            catch {
                $ErrorID = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.status
                $Message = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.detail
                $Exception = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.title
			
                Write-Host "Getting Existing Policy ID"

                Write-Error -Exception $Exception -Message $Message -ErrorId $ErrorID
            }
        }
    }
}
End {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete."
}