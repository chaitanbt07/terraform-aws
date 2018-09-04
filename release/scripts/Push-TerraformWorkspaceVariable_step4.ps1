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

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $WorkSpaceID,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        $Provider,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        $Token

    )

    Begin
    {

        Write-Host "$($MyInvocation.MyCommand.Name): Script execution started"

        $Credentials = Get-ChildItem -Path "env:$Provider*"

    }
    Process
    {

        ForEach($Credential in $Credentials)
        {

            Write-Host "$($MyInvocation.MyCommand.Name): Pushing $($Credential.Key) variable to Terraform Enterprise Workspace (ID:$WorkSpaceID)"

            try
            {
                $Credential | % {if ($_.key -match "secret") -or ($_.key -match "access"){$sensitive,$hcl,$keyname = $true,$false,$Credential.key}else{$sensitive,$hcl,$keyname =  $false,$true,$($_.key.SubString($_.key.LastIndexOf('aws_')+1))}}
		Write-host "Variable $Credential.key State: $sensitive"
		Write-Host "Variable $Credential.key Type: $hcl"
		$Json = @{
                  "data"= @{
                    "type"="vars"
                    "attributes"= @{
                      "key"=$keyname
                      "value"=$Credential.value
                      "category"="terraform"
                      "hcl"=$hcl
                      "sensitive"=$sensitive
                    }
                    "relationships"= @{
                      "workspace"= @{
                        "data"= @{
                          "id"="$WorkSpaceID"
                          "type"="workspaces"
                        }
                      }
                    }
                  }
                } | ConvertTo-Json -Depth 5

                $Post = @{

                    Uri         = "https://app.terraform.io/api/v2/vars"
                    Headers     = @{"Authorization" = "Bearer $Token" } 
                    ContentType = 'application/vnd.api+json'
                    Method      = 'Post'
                    Body        = $Json
                    ErrorAction = 'stop'

                }

                Invoke-WebRequest @Post

            }
            catch
            {

                $ErrorID = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.status
                $Message = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.detail
                $Exception = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.title

                Write-Host "$($MyInvocation.MyCommand.Name): $Message"

            }
            finally
            {
            
                Write-Host "$($MyInvocation.MyCommand.Name): Variable push complete"

            }

        }

    }
    End
    {

        Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete"

    }
