# Document NSX-v DFW with PowerNSX

Script connects to NSX Manager and vCenter using the Powershell/Powercli 
to download and create an MS Excel spreadsheet with your firewall configurations.

** Only works for Layer 3 DFW Policy

Pre-requisites to run the script are:

* [VMware PowerCLI](https://www.vmware.com/support/developer/PowerCLI/)
* [VMware PowerNSX](https://github.com/vmware/powernsx)
* [Microsoft Excel](https://products.office.com/en-au/excel) installed on the local system
* Access to NSX Manager API with privileges
* Access to vSphere Web Client and Privileges (Read)

To run the script, make sure your Powershell Execution is set to *remotesigned*

``` Powershell
Set-ExecutionPolicy remotesigned
```

PowerNSX is essential, therefore please ensure you have the latest version of PowerNSX installed,
which can be updated in an administrative PowerShell terminal with the following command:

```Powershell
Update-PowerNsx master
```

To execute the script, download it to your scripts folder and change into the folder from the PowerShell CLI
terminal and execute the command:

``` Powershell
.\DFW2Excel.ps1 
```

You are prompted to connect to an NSX Manager instance and enter your credentials, and PowerNSX also initiates a connection to vCenter. Please ensure you select yes and enter in the correct credentials. 
Once a connection to NSX Manager and vCenter has been established, the script starts an Excel Workbook and populates the worksheets with the data as required. 

Once the script has finished running, remember to save your Excel Workbook to a location of your choosing. 

### Release Notes

Version 0.6

Release Date: **06/05/2017**

* Resolved Issue 12 - _Error with $svc.name DFW2Excel.ps1:540 char:9_
* PowerNSX enhancements to universal object handling incorporated into script
* Changed VM IP Address lookup to use Extension Data from `get-vm` cmdlet

Version 0.6/0.7

Release Date: **1/04/2017**

* Remove Minor version check of NSX Manager
* remove hard-coded string `admin` from credentials request

Version 0.5

Release Date: **09/02/2017**

* Fixed issue #7 - Needed to format value as text of cell

Version 0.4

Release Date: **24/11/2016**

* Document VM IP Addresses into worksheet
* Document static membership of VMs in Security Groups
* Add warning text and simple error checks to start script

Version 0.3

Release Date: **28/10/2016**

* Object-ID for destination and source fields added to Layer 3 Firewall worksheet

Version 0.2 

Release Date: **21/10/2016**

* Fixed Casting errors that were displayed on console
* Implemented version check
* New worksheet to document Security Tags and VM Membership
* Negated Field in L3 Policy is now documented
* DFW Exclusion List

# MIT License

Copyright (c) [2016] [Tony Sangha]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
