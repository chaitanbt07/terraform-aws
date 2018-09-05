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

    [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
    $Provider,

    #Token
	[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, 
	Position=3)]
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
    $Credentials = Get-ChildItem -Path "env:$Provider*"
    #$count=0
    Write-Host "env: $($Credentials.Length)"
    For($count=0; $count -lt $($Credentials.Length);)
    {
        Write-Host "$($MyInvocation.MyCommand.Name): Updating $($Credentials[$count].Key) variable to Terraform Enterprise Workspace (Name:$WorkSpaceName)"
        Write-Host "Variablekey: $($Result[$count].attributes.key)"
        Write-Host "Variablevalue: $($Credentials[$count].value)"
        try {
            $Json = @{
                "data"= @{
                    "type"="vars"
                    "id"=$Result[$count].id
                    "attributes"= @{
                        "key"=$Result[$count].attributes.key
                        "value"=$Credentials[$count].value
                        "category"="terraform"
                        "hcl"= $hcl
                        "sensitive"= $sensitive
                    }
                } 
            } | ConvertTo-Json -Depth 5
            Write-Host "Json: $($Json)"
            $Patch = @{
                Uri = "https://app.terraform.io/api/v2/vars/$Result[$count].id"
                Headers     = @{"Authorization" = "Bearer $Token" }
                ContentType = 'application/vnd.api+json'
                Method      = 'Patch'
                Body        = $Json
                ErrorAction = 'stop'
            }

            $Update = (Invoke-RestMethod @Patch).data
            Write-Host "Update: $($Update)"
        }

        catch
            {

                $ErrorID = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.status
                $Message = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.detail
                $Exception = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.title

                Write-Error -Exception $Exception -Message $Message -ErrorId $ErrorID

            }
            finally
            {
                If ($Update) {
                Write-Host "$($MyInvocation.MyCommand.Name): Variable Update complete"
                }

            }

        $count++
    }
}
End {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete"

}
