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

    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
        Position = 2)]
    $Provider,

    #Token
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, 
        Position = 3)]
    $Token

)

Begin {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution started: Getting Variables from Workspace"

    $GET = @{
        Uri         = "https://app.terraform.io/api/v2/vars?filter%5Borganization%5D%5Bname%5D=$OrganizationName&filter%5Bworkspace%5D%5Bname%5D=$WorkSpaceName"
        Headers     = @{"Authorization" = "Bearer $Token" }
        ContentType = 'application/vnd.api+json'
        Method      = 'GET'
        ErrorAction = 'stop'
    }
    
}

Process {
    try {
        
    $Result = (Invoke-RestMethod @GET).data
    
    $Credentials = Get-ChildItem -Path "env:bamboo_$Provider*"
    
    foreach ($key in $Result) {
        $keyid = $key.id
        $keyname = $key.attributes.key
        Write-Host "For Variable: $keyname" 
        foreach ($cred in $Credentials) {
            $credkey = $cred.key
            $credvalue = $cred.value
            Write-Host "For Credential: $credvalue"
            if ($keyname -match $credkey) {
                $hcl = $false
                $sensitive = $true
                $Json = @{
                    "data" = @{
                        "type"       = "vars"
                        "id"         = $keyid
                        "attributes" = @{
                            "key"       = $keyname
                            "value"     = $credvalue
                            "category"  = "terraform"
                            "hcl"       = $hcl
                            "sensitive" = $sensitive
                        }
                    }
                } | ConvertTo-Json
                
                $Json

                $Patch = @{
                    Uri         = "https://app.terraform.io/api/v2/vars/$($keyid)"
                    Headers     = @{"Authorization" = "Bearer $Token" }
                    ContentType = 'application/vnd.api+json'
                    Method      = 'Patch'
                    Body        = $Json
                    ErrorAction = 'stop'
                }
                $Update = (Invoke-RestMethod @Patch).data
                
            }
            elseif ($($provider + "_" + $keyname) -match $credkey) {
                
                $Json = @{
                    "data" = @{
                        "type"       = "vars"
                        "id"         = $keyid
                        "attributes" = @{
                            "key"      = $keyname
                            "value"    = $credvalue
                            "category" = "terraform"
                        }
                    }
                } | ConvertTo-Json
                
                $Json

                $Patch = @{
                    Uri         = "https://app.terraform.io/api/v2/vars/$($keyid)"
                    Headers     = @{"Authorization" = "Bearer $Token" }
                    ContentType = 'application/vnd.api+json'
                    Method      = 'Patch'
                    Body        = $Json
                    ErrorAction = 'stop'
                }
                $Update = (Invoke-RestMethod @Patch).data
                }
            }
        
        }
    }

    catch {
        $ErrorID = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.status
        $Message = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.detail
        $Exception = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.title

        Write-Error -Exception $Exception -Message $Message -ErrorId $ErrorID
    }

    finally {
            If ($Result -and $Update) {
                Write-Host "$($MyInvocation.MyCommand.Name): Variable Update complete"
        }
    }
}
End {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete."
}
