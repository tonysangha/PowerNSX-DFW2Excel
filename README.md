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

You are prompted to connect to an NSX Manager instance and enter your credentials, and PowerNSX also initiates a connection to vCenter. Please ensure you select yes and enter in the correct credentials. 
Once a connection to NSX Manager and vCenter has been established, the script starts an Excel Workbook and populates the worksheets with the data as required. 

## Version 0.1 Commit notes

**Issues**

- Security Tags not documented in their own worksheet
- Negated fields not populated from configuration

**Disclaimer**:

Please test this script and development environment and ensure that it works as expected before using it a 
production environment. 