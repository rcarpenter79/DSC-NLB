# DSC-NLB

The **NLB** DSC resources allow you to configure and manage Windows Network Load Balancers.


## Description

The **NLB** module contains the **NLBCreateCluster**, **NLBAddNode**, **NLBResumeNode**, **NLBStartNode**, **NLBStopNode** and **NLBSuspendNode** DSC Resources.
These DSC Resources allow you to create a new Network Load Balancer, Add nodes to it and perform various actions against nodes. 
Please see the examples for things such as draining cluster and applying hotfixes, please note if you are working with windows updates and restarting nodes please make sure the LCM on your node is set to allow restarts.

## Resources

* **NLBCreateCluster** Creates a new NLB Cluster.
* **NLBAddNode** Adds a node to a NLB Cluster.
* **NLBResumeNode** Resume an NLB Cluster Node.
* **NLBStartNode** Start an NLB Cluster Node.
* **NLBStopNode** Stop an NLB Cluster Node.
* **NLBSuspendNode** Suspend an NLB CLuster Node.

### **NLBCreateCluster**

* **ClusterName**: Specifies the name of the new cluster
* **ClusterPrimaryIP**: Specifies the primary cluster IP address for the new cluster.
* **SubnetMask**: Specifies the subnet mask for the new cluster primary IP address.
* **DedicatedIP**: Specifies the dedicated IP address to use for the node when creating the new cluster. If this parameter is omitted, the existing static IP address on the node will be used.
* **DedicatedIPSubnetMask**: Specifies the dedicated IP address subnet mask to use for the node when creating the new cluster. If this parameter is omitted, the existing static IP address subnet mask on the node will be used.
* **InterfaceName**: Specifies the interface to which NLB is bound. This is the interface of the cluster against which this cmdlet is run.
* **OperationMode**: Specifies the operation mode for the new cluster. If this parameter is omitted, the mode is unicast. The operation mode values are unicast, multicast, or igmpmulticast.

### NLBAddNode

* **NewNodeInterface**: Specifies the interface name on the new cluster node. 
* **NewNodeName**: Specifies the name of the new cluster node.
* **ClusterName**: Specifies the name of the cluster in which the node is joining.

### NLBResumeNode

* **InterfaceName**: Specifies the name of the Interface in which you wish to resume.

### NLBStartNode

* **InterfaceName**: Specifies the name of the Interface in which you wish to start.

### NLBStopNode

* **InterfaceName**: Specifies the name of the Interface in which you wish to stop.
* **Drain**: Specifies if you wish to drain stop the node.

### NLBSuspendNode

* **InterfaceName**: Specifies the name of the Interface in which you wish to suspend.

## Versions

### 1.1.0.0

* First update which includes:
    * NLBStartNode,NLBStopNode,NLBResumeNode and NLBSuspendNode

### 1.0.0.0

* Initial release with the following resources:
    * NLBCreateCluster, NLBAddNode


## Examples

```powershell
configuration NLBConfig
{
    [CmdletBinding()]
    Param
    (
        [psCredential]
        $Credentials
    )

Import-DscResource -ModuleName NLB

    node $AllNodes.Where{$_.Role -eq "NLBServer1"}.NodeName
    {
        NLBCreateCluster CreateNLB
        {

            ClusterName = 'ClusterofBugz'
            InterfaceName = 'Load Balance'
            ClusterPrimaryIP = '192.168.0.254'
            SubnetMask = '255.255.255.0'
            OperationMode = 'IgmpMultiCast'
                  
        }

        NLBAddNode AddDC1
        {
        
            NewNodeName = 'DC1'
            NewNodeInterface = 'Load Balance'
            ClusterName = 'ClusterofBugz'
            PsDscRunAsCredential = $Credentials
            DependsOn = '[NLBCreateCluster]CreateNLB'
        
        }

        NLBAddNode AddNLB1
        {
        

            NewNodeName = 'NLB1'
            NewNodeInterface = 'Load Balance'
            ClusterName = 'ClusterofBugz'
            PsDscRunAsCredential = $Credentials
            DependsOn = '[NLBAddNode]AddDC1'        


        }

    }

}
$ConfigurationData = @{
    AllNodes = @(
        
        @{  NodeName = "NLB2"
            Role = "NLBServer1"
         }

    )
}
NLBConfig -ConfigurationData $ConfigurationData -outputpath C:\DSC -Verbose -Credentials (Get-Credential -Message "Credentials are required for adding nodes to NLB CLusters")
Start-DscConfiguration C:\DSC -verbose -wait -force
```
## Misc

During the execution of this module you may see the below warning. This may occur when adding a node to a NLB Cluster.
![Alt text](https://flynnbundy.files.wordpress.com/2016/01/nlb.png "Example")
