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
    $Policies = Get-ChildItem $Path | Select-Object Name
    New-Item ./TFE_POLICYID.txt -ItemType file
	
    foreach ($Policy in $Policies.Name) {
        write-host "For Policy: $Policy"
	
        $PolicyName = $Policy.Replace(".sentinel", "")
        try {

            $Json = @{
                "data" = @{
                    "type"       = "policies"
                    "attributes" = @{
                        "name"    = $PolicyName
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

        }
        catch {
            $ErrorID = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.status
            $Message = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.detail
            $Exception = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.title

            Write-Error -Exception $Exception -Message $Message -ErrorId $ErrorID
        }
    }
}