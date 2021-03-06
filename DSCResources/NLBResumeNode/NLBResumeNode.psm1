function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Interfacename
    )





    $returnValue = @{
    Interfacename = [System.String]$Interfacename
    }

    $returnValue
    
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Interfacename
    )

Write-Verbose "Resuming $Interfacename"
Get-NlbClusterNode -InterfaceName $Interfacename | Resume-NlbClusterNode

}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Interfacename
    )

if (Get-NlbClusterNode -InterfaceName $Interfacename -ErrorAction SilentlyContinue | Where {$_.State -eq 'Suspended'}){

return $false
}
else{

return $true
}

}


Export-ModuleMember -Function *-TargetResource

