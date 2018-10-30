[CmdletBinding()]
[Alias()]
[OutputType([object])]
Param                                                                                                                                                 
(                                                                                                                                                 
    #Organization
	[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, 
	Position=0)] 
	$Organization,
	#Workspace
    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, 
	Position=1)]
	$WorkSpaceName,
	#Token
	[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, 
	Position=2)]
	$Token
)

Begin {
    Write-Host "$($MyInvocation.MyCommand.Name): Script Execution Started"

    $Json = @{
        "data" = @{
            "attributes" = @{
                "name"       = "$WorkSpaceName"
                "auto-apply" = $false
            }
            "type"       = "workspaces"
        }
    } | ConvertTo-Json

    $Post = @{
        Uri         = "https://app.terraform.io/api/v2/organizations/$Organization/workspaces"
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

        Write-Host ('##vso[task.setvariable variable=TFE_WORKSPACEID]{0}' -f $Result.id)
	    Write-Output "TFE_WORKSPACE_ID=$($Result.id)" |out-file ./TFE_WORKSPACEID.txt 
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
    If ($ErrorID -eq 422) {
        Write-Host "$($MyInvocation.MyCommand.Name): $Message. Getting workspace ID."

        try {
            $Patch = @{
                Uri = "https://app.terraform.io/api/v2/organizations/$Organization/workspaces/$WorkSpaceName"
                Headers     = @{"Authorization" = "Bearer $Token" }
                ContentType = 'application/vnd.api+json'
                Method      = 'Patch'
                Body        = $Json
                ErrorAction = 'stop'
            }
            
            $Patch_Result = (Invoke-RestMethod @Patch).data

            $Patch_Result

            $Get = @{

                Uri         = "https://app.terraform.io/api/v2/organizations/$Organization/workspaces/$WorkSpaceName"
                Headers     = @{"Authorization" = "Bearer $Token" }
                ContentType = 'application/vnd.api+json'
                Method      = 'Get'
                ErrorAction = 'stop'
            }

            $Result = (Invoke-RestMethod @Get).data

            #Write-Host ('##vso[task.setvariable variable=TFE_WORKSPACEID]{0}' -f $Result.id)
	        Write-Output "TFE_WORKSPACE_ID=$($Result.id)" |out-file ./TFE_WORKSPACEID.txt 
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
}
End {
}
