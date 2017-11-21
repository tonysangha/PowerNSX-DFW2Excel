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

PowerNSX is essential, therefore please ensure you have the latest supported version of PowerNSX installed,
which can be installed in an administrative PowerShell terminal from the [PowerShell Gallery](https://www.powershellgallery.com/packages/PowerNSX/3.0.1047)

```Powershell
Install-Module -Name PowerNSX 
```
The script has been tested against version **3.0.1047**, support for other PowerNSX versions is not tested. 

To verify what PowerNSX version you have running execute the command:

```Powershell
Get-PowerNsxVersion

Version  Path                                                                     Author        CompanyName
-------  ----                                                                     ------        -----------
3.0.1047 C:\Users\Tony\Documents\WindowsPowerShell\Modules\powernsx\PowerNSX.psm1 Nick Bradford VMware
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

Version 1.0.1

Release Date: **21/11/2017**

* Added prompt to check if user wants to get VM Security Group Membership
* Rudimentary validation check of yes/no prompt added
* Added new worksheet titled _Environment Summary_
* Security Group Statistics included to resolve issue: #19

Version 1.0.0

Release Date: **08/10/2017**

* Hyperlink Support in FW Rule sheet to: VMs, IPSets, Services, Security Groups
* Sample output file updated

Version 0.9.2

Release Date: **06/10/2017**

* If Service Field is not a NSX Object, output raw `Protocol/Port` into Cell
* Collasped hash table for local/universal services into a single table - as it's now using objectID for unique field

Version 0.9.1

Release Date: **06/10/2017**

* New Column - object-ids added to service and service group tabs.
* Instead of using service names, using object-id's instead for hashtable to build hyperlink
* For Service Group Hyperlinks, provide tooltip which is object-id
* Hyperlink from Exclusion List VMs & Sec Grp VMs to VM_Info sheet

Version 0.9

Release Date: **06/10/2017**

* If `$NSXDefaultConnection` exists, do not prompt for a new NSX Manager connection
* When retrieving objects, specify scope - do not rely on defaults
* [New Feature] - Hyperlinks from Service Groups to Services

Version 0.8

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
