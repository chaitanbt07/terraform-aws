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
    Write-Host "Results: $($Result.attributes.key)"
    Write-Host "Credentials: $($Credentials.key)"
    #[string]$resultstring = $Result -join ","
    #Write-Host "resultstring : $($resultstring)"
    ForEach($Credential in $Credentials)
    {
        $count = 0
        Write-Host "Inside For Individual cred: $($Credential.key) = $($Credential.value)"
        write-host "Result Value: $($Result[$count].attributes.key)"
        $Credential | % {if ($_.key -match $Result.attributes.key)
        {
            Write-Host "Inside If"
                Write-Host "$($Result[$count].id) = $($Result[$count].attributes.key) for $($Credential.key) = $($Credential.value)"
            try {
                write-host "Inside try"
                $Json = @{
                    "data"= @{
                        "type"="vars"
                        "id"=$Result[$count].id
                        "attributes"= @{
                            "key"=$Result[$count].attributes.key
                            "value"=$Credentials.value
                            "category"="terraform"
                            }
                    }
                } | ConvertTo-Json

    $Patch = @{
                Uri = "https://app.terraform.io/api/v2/vars/$($Result[$count].id)"
                Headers     = @{"Authorization" = "Bearer $Token" }
                ContentType = 'application/vnd.api+json'
                Method      = 'Patch'
                Body        = $Json
                ErrorAction = 'stop'
            }
            Write-Host "Patch output$($Patch)"
                    $Update = (Invoke-RestMethod @Patch).data
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
            else { 
                write-host "else output"
                $count++ 
            }
}
}
}
End {

    Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete"

}
