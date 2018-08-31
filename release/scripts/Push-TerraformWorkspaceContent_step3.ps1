[CmdletBinding()]
[Alias()]
[OutputType([int])]
Param
(
    # Workspace
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    $Uri,

    # Token
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
    $Path

)

Begin {
    Write-Host "$($MyInvocation.MyCommand.Name): Script Execution Started"

    $Put = @{

        Uri         = $Uri
        Method      = 'Put'
        InFile      = $Path
        ErrorAction = 'stop'
    }

}

Process {
    try {
        Invoke-RestMethod @Put
    }
    catch {
        $ErrorID = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.status
        $Message = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.detail
        $Exception = ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.title

        Write-Error -Exception $Exception -Message $Message -ErrorId $ErrorID
    }
    finally {

        Write-Host "$($MyInvocation.MyCommand.Name): Script execution complete"

    }
}
End {
}