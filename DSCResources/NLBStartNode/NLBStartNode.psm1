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


Write-Verbose "Starting $Interfacename"
Get-NlbClusterNode -InterfaceName $Interfacename | Start-NlbClusterNode 


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

if (Get-NlbClusterNode -InterfaceName $Interfacename -ErrorAction SilentlyContinue | Where {$_.State -like 'Converged*'}){

return $true
}
else{

return $false
}

}

Export-ModuleMember -Function *-TargetResource

