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

    [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
    $Provider,

    #Token
	[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, 
	Position=3)]
	$Token

)

Begin 
{

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution started: Getting Variables from Workspace"

    $GET = @{
        Uri         = "https://app.terraform.io/api/v2/vars?filter%5Borganization%5D%5Bname%5D=$OrganizationName&filter%5Bworkspace%5D%5Bname%5D=$WorkSpaceName"
        Headers     = @{"Authorization" = "Bearer $Token" }
        ContentType = 'application/vnd.api+json'
        Method      = 'GET'
        ErrorAction = 'stop'
    }
    
}

Process 
{
    $Result = (Invoke-RestMethod @GET).data
    Write-Host "Results from TFE: $($Results)"
    $Credentials = Get-ChildItem -Path "env:$Provider*"
    Write-Host "Results key from Bamboo Variable: $($Credentials.key)"
    foreach ($key in $Result) {
        $keyid = $key.id
        $keyname = $key.attributes.key
        foreach ($cred in $Credentials) {
            $credkey = $cred.key
            $credvalue = $cred.value
            if ($keyname -match $credkey) {
                Write-Host "Result key: $($keyname) and Credentials key: $($credkey) matches"
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
            }
        }
        
    }
}
End {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete"

}