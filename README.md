# PowerNSX-Scripts
Powershell scripts using the PowerNSX Module for VMware vSphere NSX

Please submit any issues encountered via the Issues page on this repository

# Document NSX-v DFW with PowerNSX

This script connects to NSX Manager and vCenter using the appropriate methods, 
to download and create an MS Excel spreadsheet with your firewall configurations.

Pre-requisites to run the script are:

* [VMware PowerCLI](https://www.vmware.com/support/developer/PowerCLI/)
* [VMware PowerNSX](https://github.com/vmware/powernsx)
* [Microsoft Excel](https://products.office.com/en-au/excel) installed on the local system
* Access to NSX Manager API with privileges
* Access to vSphere Web Client and Privileges (Read)

To run the script, make sure your Powershell Execution is set to *remotesigned*

```Set-ExecutionPolicy remotesigned```

To run the script, execute the command:

``` .\DFW2Excel.ps1 ```

You will be prompted to connect to an NSX Manager and enter the username/password, PowerNSX will also
initate a connection to vCenter, please ensure you select yes and enter in the correct credentials. 
Once a connection to NSX Manager and vCenter have been established, the script will start an Excel
Workbook and populate the worksheets with the data as required. 