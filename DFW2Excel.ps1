# Author:   Tony Sangha
# Blog:    tonysangha.com
# Version:  0.1
# PowerCLI v6.0
# PowerNSX v2.0

# Import PowerCLI modules, PowerCLI must be installed
if ( !(Get-Module -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue) ) {
    if (Test-Path -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\VMware, Inc.\VMware vSphere PowerCLI' ) {
        $Regkey = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\VMware, Inc.\VMware vSphere PowerCLI'

    } else {
        $Regkey = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\VMware, Inc.\VMware vSphere PowerCLI'
    }
    . (join-path -path (Get-ItemProperty  $Regkey).InstallPath -childpath 'Scripts\Initialize-PowerCLIEnvironment.ps1')
}
if ( !(Get-Module -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue) ) {
    Write-Host "VMware modules not loaded/unable to load"
    Exit 99
}

# Import PowerNSX Module
import-module PowerNSX


########################################################
#    Formatting Options for Excel Spreadsheet
########################################################

    $titleFontSize = 18
    $titleFontBold = $True
    $titleFontColorIndex = 2
    $titleFontName = "Calibri (Body)"
    $titleInteriorColor = 10

    $subTitleFontSize = 10.5
    $subTitleFontBold = $True
    $subTitleFontName = "Calibri (Body)"
    $subTitleInteriorColor = 43

    $valueFontName = "Calibri (Body)"
    $valueFontSize = 10.5
    $valueMissingColorIndex =
    $valueMissingText = "<BLANK>"
    $valueMissingHighlight = 6
    $valueNotApplicable = "<NOT APPLICABLE>"
    $valueNotDefined = "<NOT DEFINED>"

########################################################
#    Define Excel Workbook and calls to different WS
########################################################
function startExcel(){

    $Excel = New-Object -Com Excel.Application
    $Excel.visible = $True
    $Excel.DisplayAlerts = $false
    $wb = $Excel.Workbooks.Add()

    $ws1 = $wb.WorkSheets.Add()
    $ws1.Name = "Service Groups"
    service_groups_ws($ws1)
    $usedRange = $ws1.UsedRange
    $usedRange.EntireColumn.Autofit()

    $ws2 = $wb.WorkSheets.Add()
    $ws2.Name = "Services"
    services_ws($ws2)
    $usedRange = $ws2.UsedRange
    $usedRange.EntireColumn.Autofit()

    $ws3 = $wb.WorkSheets.Add()
    $ws3.Name = "MACSETS"
    macset_ws($ws3)
    $usedRange = $ws3.UsedRange
    $usedRange.EntireColumn.Autofit()

    $ws4 = $wb.WorkSheets.Add()
    $ws4.Name = "IPSETS"
    ipset_ws($ws4)
    $usedRange = $ws4.UsedRange
    $usedRange.EntireColumn.Autofit()

    $ws5 = $wb.WorkSheets.Add()
    $ws5.Name = "Security Groups"
    sg_ws($ws5)
    $usedRange = $ws5.UsedRange
    $usedRange.EntireColumn.Autofit()

    $ws6 = $wb.Worksheets.Add()
    $ws6.Name = "Security Tags"
    sec_tags_ws($ws6)
    $usedRange = $ws6.UsedRange
    $usedRange.EntireColumn.Autofit()
	
	$ws7 = $wb.Worksheets.Add()
    $ws7.Name = "DFW Exclusion list"
    ex_list_ws($ws7)
    $usedRange = $ws7.UsedRange
    $usedRange.EntireColumn.Autofit()
	
	$ws8 = $wb.Worksheets.Add()
    $ws8.Name = "Layer 3 Firewall"
    dfw_ws($ws8)
    $usedRange = $ws8.UsedRange
    $usedRange.EntireColumn.Autofit()
	
	

}

########################################################
#    Firewall Worksheet (Only Layer 3)
########################################################

function dfw_ws($sheet){

    $sheet.Cells.Item(1,1) = "Firewall Configuration"
    $sheet.Cells.Item(1,1).Font.Size = $titleFontSize
    $sheet.Cells.Item(1,1).Font.Bold = $titleFontBold
    $sheet.Cells.Item(1,1).Font.ColorIndex = $titleFontColorIndex
    $sheet.Cells.Item(1,1).Font.Name = $titleFontName
    $sheet.Cells.Item(1,1).Interior.ColorIndex = $titleInteriorColor
    $range1 = $sheet.Range("a1", "q1")
    $range1.merge() | Out-Null

    l3_rules($sheet)
}

function l3_rules($sheet){

    $sheet.Cells.Item(2,1) = "Layer 3 Rules"
    $sheet.Cells.Item(2,1).Font.Bold = $titleFontBold
    $sheet.Cells.Item(2,1).Font.ColorIndex = $titleFontColorIndex
    $sheet.Cells.Item(2,1).Font.Name = $titleFontName
    $sheet.Cells.Item(2,1).Interior.ColorIndex = $titleInteriorColor
    $range1 = $sheet.Range("a2", "q2")

    $sheet.Cells.Item(3,1) = "Section Name"
    $sheet.Cells.Item(3,2) = "Section ID"

    $sheet.Cells.Item(3,3) = "Rule Status"
    $sheet.Cells.Item(3,4) = "Rule Name"
    $sheet.Cells.Item(3,5) = "Rule ID"

    $sheet.Cells.Item(3,6) = "Source Excluded (Negated)"
    $sheet.Cells.Item(3,7) = "Source Type"
    $sheet.Cells.Item(3,8) = "Source Name"

    $sheet.Cells.Item(3,9) = "Destination Excluded (Negated)"
    $sheet.Cells.Item(3,10) = "Destination Type"
    $sheet.Cells.Item(3,11) = "Destination Name"

    $sheet.Cells.Item(3,12) = "Service Name"
    $sheet.Cells.Item(3,13) = "Action"
    $sheet.Cells.Item(3,14) = "Direction"
    $sheet.Cells.Item(3,15) = "Packet Type"
    $sheet.Cells.Item(3,16) = "Applied To"
    $sheet.Cells.Item(3,17) = "Log"

    $range2 = $sheet.Range("a3", "q3")
    $range2.Font.Size = $subTitleFontSize
    $range2.Font.Bold = $subTitleFontBold
    $range2.Interior.ColorIndex = $subTitleInteriorColor
    $range2.Font.Name = $subTitleFontName

    $fw_sections = Get-NSXFirewallSection

    $row = 4

    foreach($section in $fw_sections){
        $sheet.Cells.Item($row,1) = $section.name
        $sheet.Cells.Item($row,1).Font.Bold = $true
        $sheet.Cells.Item($row,2) = $section.id
        $sheet.Cells.Item($row,2).Font.Bold = $true

        foreach($rule in $section.rule){

            if($rule.disabled -eq "false"){
                $sheet.Cells.Item($row,3) = "Enabled"
            } else {
                $sheet.Cells.Item($row,3) = "Disabled"
            }
            if ($rule.name -eq "rule"){
                $sheet.Cells.Item($row,4) = $valueNotDefined
                } else {
                    $sheet.Cells.Item($row,4) = $rule.name
                    $sheet.Cells.Item($row,4).Font.Bold = $true
                }
            $sheet.Cells.Item($row,5) = $rule.id
            $sheet.Cells.Item($row,5).Font.Bold = $true

            # Highlight Allow/Deny statements
            if($rule.action -eq "deny"){
                $sheet.Cells.Item($row,13) = $rule.action
                $sheet.Cells.Item($row,13).Font.ColorIndex = 3
            } elseif($rule.action -eq "allow"){
                $sheet.Cells.Item($row,13) = $rule.action
                $sheet.Cells.Item($row,13).Font.ColorIndex = 4
            }

            $sheet.Cells.Item($row,14) = $rule.direction
            $sheet.Cells.Item($row,15) = $rule.packetType
            $sheet.Cells.Item($row,17) = $rule.logged

            ###### Sources Section ######
            $srcRow = $row

            # If Source does not exist, it must be set to ANY
            if (!$rule.sources){
                $sheet.Cells.Item($srcRow,8) = "ANY"
                $sheet.Cells.Item($srcRow,8).Font.ColorIndex = 45
            } else {
                foreach($source in $rule.sources.source){
                    $sheet.Cells.Item($srcRow,7) = $source.type

                    if($source.type -eq "Ipv4Address"){
                        $sheet.Cells.Item($srcRow,8) = $source.value
                    } elseif($source.type -eq "Ipv6Address") {
                        $sheet.Cells.Item($srcRow,8) = $source.value
                    } else {
                        $sheet.Cells.Item($srcRow,8) = $source.name
                    }
                $srcRow++
                }
            }

            ###### Destination Section ######
            $dstRow = $row

            # If Destination does not exist, it must be set to ANY
            if (!$rule.destinations){
                $sheet.Cells.Item($dstRow,11) = "ANY"
                $sheet.Cells.Item($dstRow,11).Font.ColorIndex = 45
            } else {
                foreach($destination in $rule.destinations.destination){
                    $sheet.Cells.Item($dstRow,10) = $destination.type
                    if($destination.type -eq "Ipv4Address"){
                        $sheet.Cells.Item($dstRow,11) = $destination.value
                        } elseif($destination.type -eq "Ipv6Address") {
                            $sheet.Cells.Item($dstRow,11) = $destination.value
                        } else {
                            $sheet.Cells.Item($dstRow,11) = $destination.name
                        }
                    $dstRow++
                }
            }

            ###### Services Section ######
            $svcRow = $row

            # If Service does not exist, it must be set to ANY
            if(!$rule.services){
                $sheet.Cells.Item($svcRow,12) = "ANY"
                $sheet.Cells.Item($svcRow,12).Font.ColorIndex = 45
            } else {
                foreach($service in $rule.services.service){
                    $sheet.Cells.Item($svcRow,12) = $service.name
                    $svcRow++
                }
            }

            ###### AppliedTo ######
            $appRow = $row

            foreach($appliedTo in $rule.appliedToList.appliedTo){
                $sheet.Cells.Item($appRow,16) = $appliedTo.name
                $appRow++
            }
            $row = ($srcRow,$dstRow,$svcRow,$appRow | Measure-Object -Maximum).Maximum
        }
        $row++
        $sheet.Cells.Item($row,1).Interior.ColorIndex = $titleInteriorColor
        $range1 = $sheet.Range("a"+$row, "q"+$row)
        $range1.merge() | Out-Null
        $row++

    }
}

########################################################
#    Security Groups - Dynamic Membership only
########################################################

function sg_ws($sheet){

    $sheet.Cells.Item(1,1) = "Security Group Configuration"
    $sheet.Cells.Item(1,1).Font.Size = $titleFontSize
    $sheet.Cells.Item(1,1).Font.Bold = $titleFontBold
    $sheet.Cells.Item(1,1).Font.ColorIndex = $titleFontColorIndex
    $sheet.Cells.Item(1,1).Font.Name = $titleFontName
    $sheet.Cells.Item(1,1).Interior.ColorIndex = $titleInteriorColor
    $range1 = $sheet.Range("a1", "j1")
    $range1.merge() | Out-Null

    $sheet.Cells.Item(2,1) = "Name"
    $sheet.Cells.Item(2,2) = "Scope"
    $sheet.Cells.Item(2,3) = "Universal"
    $sheet.Cells.Item(2,4) = "Inheritance Allowed"
    $sheet.Cells.Item(2,5) = "Group Type (Dynamic/Static)"
    $sheet.Cells.Item(2,6) = "Dynamic Query Key Value"
    $sheet.Cells.Item(2,7) = "Dynamic Query Operator"
    $sheet.Cells.Item(2,8) = "Dynamic Query Criteria"
    $sheet.Cells.Item(2,9) = "Dynamic Query Value"
    $range2 = $sheet.Range("a2", "j2")
    $range2.Font.Size = $subTitleFontSize
    $range2.Font.Bold = $subTitleFontBold
    $range2.Interior.ColorIndex = $subTitleInteriorColor
    $range2.Font.Name = $subTitleFontName
    pop_sg_ws($sheet)
}

function pop_sg_ws($sheet){

    $sg = Get-NSXSecurityGroup
    $row = 3
    foreach ($member in $sg){

        if($member.dynamicMemberDefinition){

            $sheet.Cells.Item($row,1) = $member.name
            $sheet.Cells.Item($row,2) = $member.scope.name
            $sheet.Cells.Item($row,3) = $member.isUniversal
            $sheet.Cells.Item($row,4) = $member.inhertianceAllowed
            
            $sheet.Cells.Item($row,5) = "Dynamic"
            
            foreach ($entity in $member.dynamicMemberDefinition.dynamicSet.dynamicCriteria){
                $sheet.Cells.Item($row,6) = $entity.key
                $sheet.Cells.Item($row,7) = $entity.operator
                $sheet.Cells.Item($row,8) = $entity.criteria
                $sheet.Cells.Item($row,9) = $entity.value
                $row++
            }
        }
        else{
            $sheet.Cells.Item($row,1) = $member.name
            $sheet.Cells.Item($row,2) = $member.scope.name
            $sheet.Cells.Item($row,3) = $member.isUniversal
            $sheet.Cells.Item($row,4) = $member.inhertianceAllowed
            
            $sheet.Cells.Item($row,5) = "Static"
            $row++
        }
    }
    
    $sheet.Cells.Item($row,1) = "Security Group Membership"
    $sheet.Cells.Item($row,1).Font.Size = $titleFontSize
    $sheet.Cells.Item($row,1).Font.Bold = $titleFontBold
    $sheet.Cells.Item($row,1).Font.ColorIndex = $titleFontColorIndex
    $sheet.Cells.Item($row,1).Font.Name = $titleFontName
    $sheet.Cells.Item($row,1).Interior.ColorIndex = $titleInteriorColor
    $range2 = $sheet.Range("a"+$row, "j"+$row)
    $range2.merge() | Out-Null

    $row++
    
    $sheet.Cells.Item($row,1) = "SG Name"
    $sheet.Cells.Item($row,2) = "VM ID"
    $sheet.Cells.Item($row,3) = "VM Name"
    $range3 = $sheet.Range("a"+$row, "c"+$row)
    $range3.Font.Size = $subTitleFontSize
    $range3.Font.Bold = $subTitleFontBold
    $range3.Interior.ColorIndex = $subTitleInteriorColor
    $range3.Font.Name = $subTitleFontName
    
    $row++

    foreach ($member in $sg){

        $members = $member | Get-NSXSecurityGroupEffectiveMembers

        $sheet.Cells.Item($row,1) = $member.name

        foreach ($vm in $members.DynamicIncludeVM.vmnode){
            $sheet.Cells.Item($row,2) = $vm.vmID
            $sheet.Cells.Item($row,3) = $vm.vmName
            $row++
        }
    }
}

########################################################
#    IPSETS Worksheet
########################################################

function ipset_ws($sheet){

    $sheet.Cells.Item(1,1) = "IPSET Configuration"
    $sheet.Cells.Item(1,1).Font.Size = $titleFontSize
    $sheet.Cells.Item(1,1).Font.Bold = $titleFontBold
    $sheet.Cells.Item(1,1).Font.ColorIndex = $titleFontColorIndex
    $sheet.Cells.Item(1,1).Font.Name = $titleFontName
    $sheet.Cells.Item(1,1).Interior.ColorIndex = $titleInteriorColor
    $range1 = $sheet.Range("a1", "d1")
    $range1.merge() | Out-Null

    $sheet.Cells.Item(2,1) = "Name"
    $sheet.Cells.Item(2,2) = "Value"
    $sheet.Cells.Item(2,3) = "Universal"
    $sheet.Cells.Item(2,4) = "Description"
    $range2 = $sheet.Range("a2", "d2")
    $range2.Font.Size = $subTitleFontSize
    $range2.Font.Bold = $subTitleFontBold
    $range2.Interior.ColorIndex = $subTitleInteriorColor
    $range2.Font.Name = $subTitleFontName
    pop_ipset_ws($sheet)
}

function pop_ipset_ws($sheet){

    $row=3
    $ipset = get-nsxipset
    foreach ($ip in $ipset) {

        $sheet.Cells.Item($row,1) = $ip.name
        $sheet.Cells.Item($row,2) = $ip.value
        $sheet.Cells.Item($row,3) = $ip.isUniversal
        if(!$ip.description){
            $sheet.Cells.Item($row,4) = $valueNotDefined
        }
        else {$sheet.Cells.Item($row,4) = $ip.description}

        $row++ # Increment Rows
    }
}
########################################################
#    MACSETS Worksheet
########################################################

function macset_ws($sheet){

    $sheet.Cells.Item(1,1) = "MACSET Configuration"
    $sheet.Cells.Item(1,1).Font.Size = $titleFontSize
    $sheet.Cells.Item(1,1).Font.Bold = $titleFontBold
    $sheet.Cells.Item(1,1).Font.ColorIndex = $titleFontColorIndex
    $sheet.Cells.Item(1,1).Font.Name = $titleFontName
    $sheet.Cells.Item(1,1).Interior.ColorIndex = $titleInteriorColor
    $range1 = $sheet.Range("a1", "e1")
    $range1.merge() | Out-Null

    $sheet.Cells.Item(2,1) = "Name"
    $sheet.Cells.Item(2,2) = "Value"
    $sheet.Cells.Item(2,3) = "Description"
    $range2 = $sheet.Range("a2", "c2")
    $range2.Font.Size = $subTitleFontSize
    $range2.Font.Bold = $subTitleFontBold
    $range2.Interior.ColorIndex = $subTitleInteriorColor
    $range2.Font.Name = $subTitleFontName
    pop_macset_ws($sheet)
}

function pop_macset_ws($sheet){

    # Grab MACSets and populate
    $row=3
    $macset = get-nsxmacset
    foreach ($mac in $macset) {

        $sheet.Cells.Item($row,1) = $mac.name
        $sheet.Cells.Item($row,2) = $mac.value
        if(!$mac.description){
            $sheet.Cells.Item($row,3) = $valueNotDefined
        }
        else {$sheet.Cells.Item($row,3) = $mac.description}

        $row++ # Increment Rows
    }
}

########################################################
#    Services Worksheet
########################################################

function services_ws($sheet){

    $sheet.Cells.Item(1,1) = "DFW Services Configuration"
    $sheet.Cells.Item(1,1).Font.Size = $titleFontSize
    $sheet.Cells.Item(1,1).Font.Bold = $titleFontBold
    $sheet.Cells.Item(1,1).Font.ColorIndex = $titleFontColorIndex
    $sheet.Cells.Item(1,1).Font.Name = $titleFontName
    $sheet.Cells.Item(1,1).Interior.ColorIndex = $titleInteriorColor
    $range1 = $sheet.Range("a1", "f1")
    $range1.merge() | Out-Null

    $sheet.Cells.Item(2,1) = "Name"
    $sheet.Cells.Item(2,2) = "Type"
    $sheet.Cells.Item(2,3) = "Application Protocol"
    $sheet.Cells.Item(2,4) = "Value"
    $sheet.Cells.Item(2,5) = "Universal"
    $range2 = $sheet.Range("a2", "e2")
    $range2.Font.Size = $subTitleFontSize
    $range2.Font.Bold = $subTitleFontBold
    $range2.Interior.ColorIndex = $subTitleInteriorColor
    $range2.Font.Name = $subTitleFontName
    pop_services_ws($sheet)
}

function pop_services_ws($sheet){

    # Grab MACSets and populate
    $row=3
    $services = get-nsxservice
    foreach ($svc in $services) {

        $sheet.Cells.Item($row,1) = $svc.name
        $sheet.Cells.Item($row,2) = $svc.type.typeName
        $sheet.Cells.Item($row,3) = $svc.element.applicationProtocol
        $sheet.Cells.Item($row,4) = $svc.element.value
        $sheet.Cells.Item($row,5) = $svc.isUniversal

        $row++ # Increment Rows
    }
}

########################################################
#    Service Groups Worksheet
########################################################

function service_groups_ws($sheet){

    $sheet.Cells.Item(1,1) = "Service Group Configuration"
    $sheet.Cells.Item(1,1).Font.Size = $titleFontSize
    $sheet.Cells.Item(1,1).Font.Bold = $titleFontBold
    $sheet.Cells.Item(1,1).Font.ColorIndex = $titleFontColorIndex
    $sheet.Cells.Item(1,1).Font.Name = $titleFontName
    $sheet.Cells.Item(1,1).Interior.ColorIndex = $titleInteriorColor
    $range1 = $sheet.Range("a1", "f1")
    $range1.merge() | Out-Null

    $sheet.Cells.Item(2,1) = "Service Group Name"
    $sheet.Cells.Item(2,2) = "Universal"
    $sheet.Cells.Item(2,3) = "Scope"
    $sheet.Cells.Item(2,4) = "Service Members"
    $range2 = $sheet.Range("a2", "d2")
    $range2.Font.Size = $subTitleFontSize
    $range2.Font.Bold = $subTitleFontBold
    $range2.Interior.ColorIndex = $subTitleInteriorColor
    $range2.Font.Name = $subTitleFontName
    pop_service_groups_ws($sheet)
}

function pop_service_groups_ws($sheet){

    $row=3
    $SG = Get-NSXServiceGroup

    foreach ($svc_mem in $SG) {
        $sheet.Cells.Item($row,1) = $svc_mem.name
        $sheet.Cells.Item($row,1).Font.Bold = $true
        $sheet.Cells.Item($row,2) = $svc_mem.isUniversal
        $sheet.Cells.Item($row,3) = $svc_mem.scope.name

        if (!$svc_mem.member) {
                $row++ # Increment Rows
            }
        else {
            foreach ($member in $svc_mem.member){
            $sheet.Cells.Item($row,4) = $member.name
            $row++ # Increment Rows
            }
        }
    }
}
########################################################
#    Security Tag Worksheet
########################################################

function sec_tags_ws($sheet){

    $sheet.Cells.Item(1,1) = "Security Tag Configuration"
    $sheet.Cells.Item(1,1).Font.Size = $titleFontSize
    $sheet.Cells.Item(1,1).Font.Bold = $titleFontBold
    $sheet.Cells.Item(1,1).Font.ColorIndex = $titleFontColorIndex
    $sheet.Cells.Item(1,1).Font.Name = $titleFontName
    $sheet.Cells.Item(1,1).Interior.ColorIndex = $titleInteriorColor
    $range1 = $sheet.Range("a1", "f1")
    $range1.merge() | Out-Null

    $sheet.Cells.Item(2,1) = "Security Tag Name"
    $sheet.Cells.Item(2,2) = "Built-In"
    $sheet.Cells.Item(2,3) = "VM Members"
    $sheet.Cells.Item(2,4) = "Description"
    $range2 = $sheet.Range("a2", "d2")
    $range2.Font.Size = $subTitleFontSize
    $range2.Font.Bold = $subTitleFontBold
    $range2.Interior.ColorIndex = $subTitleInteriorColor
    $range2.Font.Name = $subTitleFontName
    pop_sec_tags_ws($sheet)
}

function pop_sec_tags_ws($sheet){

    $row=3
    $ST = get-nsxsecuritytag -includesystem

    foreach ($tag in $ST) {
        $sheet.Cells.Item($row,1) = $tag.name
        $sheet.Cells.Item($row,2) = $tag.systemResource
        $sheet.Cells.Item($row,3) = $tag.vmCount
		$sheet.Cells.Item($row,4) = $tag.systemResource
		$row++ # Increment Rows
    }
}
########################################################
#    Exclusion list Worksheet
########################################################

function ex_list_ws($sheet){

    $sheet.Cells.Item(1,1) = "Exclusion List"
    $sheet.Cells.Item(1,1).Font.Size = $titleFontSize
    $sheet.Cells.Item(1,1).Font.Bold = $titleFontBold
    $sheet.Cells.Item(1,1).Font.ColorIndex = $titleFontColorIndex
    $sheet.Cells.Item(1,1).Font.Name = $titleFontName
    $sheet.Cells.Item(1,1).Interior.ColorIndex = $titleInteriorColor
    $range1 = $sheet.Range("a1", "f1")
    $range1.merge() | Out-Null

    $sheet.Cells.Item(2,1) = "VM Name"
    $range2 = $sheet.Range("a2", "a2")
    $range2.Font.Size = $subTitleFontSize
    $range2.Font.Bold = $subTitleFontBold
    $range2.Interior.ColorIndex = $subTitleInteriorColor
    $range2.Font.Name = $subTitleFontName
    pop_ex_list_ws($sheet)
}

function pop_ex_list_ws($sheet){

    $row=3
    $guests = Get-NsxFirewallExclusionListMember

    foreach ($vm in $guests) {
        $sheet.Cells.Item($row,1) = $vm.name
		$row++ # Increment Rows
    }
}
########################################################
#    Global Functions
########################################################

# Ask from user
$nsx_mgr = Read-Host "IP or FQDN of NSX Manager? "
Connect-NSXServer $nsx_mgr
startExcel

