$filePath="C:\ServiceInspector\"
$filePathMaster=$filePath+"\MasterServiceList.csv"
$fileSelector= Read-Host -Prompt "Do you want to test against a different file? ((y/n) default file: masterlist)"
Write-Host
Write-Host
Write-Host
#Handles using different files from the masterlist

if($fileSelector -eq "y"){
   [array]$fileList=Get-ChildItem $filePath | Where-Object{$_.Name -notmatch 'Master'}
   for($i=0; $i -lt $fileList.length; $i++){
   Write-Host "$i - "$filelist[$i] 
   }
   Write-Host
   Write-Host
   $innerFileSelector=Read-Host -prompt "Input the number of the desired file and press enter"
   $filePathMaster=$filepath+$fileList[$innerFileSelector]
   
   
}
Write-Host "you're using the file $filePathMaster"
Write-Host
Write-Host
Write-Host


#Imports the chosen list, getting just the names of the services
$oldServList=@(Import-Csv -Path $filePathMaster -Delimiter ';' )
$oldNameList =[System.Collections.ArrayList]::new()
foreach($item in $oldServList){
	$itemName = $item.Name
	if($itemName -match "^[a-zA-z]+[_]+[0-9a-zA-Z]+"){
		#parses out the PID written after the "_" character, to avoid false positives
		$pos =$itemName.IndexOf("_")
		$leftPart = $itemName.Substring(0, $pos)
		$oldNameList.Add($leftPart) | out-null
	}
	else{
		$oldNameList.Add($itemName) | out-null
	}
}
#Write-Host $oldNameList #Optional, used for debug

Write-Host "Service List acquired from csv"
Write-Host
Write-Host
Write-Host
#Imports the active services list and saves it in a string list containing only the services' names
$newNameList =[System.Collections.ArrayList]::new()
$newServList=@(Get-Service | Where-Object {$_.Status -eq 'running'})
foreach ($item in $newServList){
	$itemName = $item.Name
	if($itemName -match "^[a-zA-z]+[_]+[0-9a-zA-Z]+"){
		#parses out the PID written after the "_" character, to avoid false positives
		$pos =$itemName.IndexOf("_")
		$leftPart = $itemName.Substring(0, $pos)
		$newNameList.Add($leftPart) | out-null
	}
	else{
		$newNameList.Add($item.Name)| out-null
	}
}




#newly activated services output list
$outputArrAct=[System.Collections.ArrayList]::new()

#stopped services output list 
$outputArrStop=[System.Collections.ArrayList]::new()

Write-Host "Testing..."

#Tests wether the new service names are contained in the old list, if not, saves them to the newly activated output list.
foreach ($j in $newNameList){
	#$newName=$j.Name
	if (-not($oldNameList.Contains($j))){
		$outputArrAct.Add($j) | Out-Null
    }
}

#Tests wether the old service names are contained in the new list, if not, saves them to the stopped services output list.
foreach ($n in $oldNameList){
	#$oldName=$n.Name
	if (-not($newNameList.Contains($n))){
		$outputArrStop.Add($n) | Out-Null
	}
}
$selectedFileName= $filePathMaster.split("\")[-1]
Write-Host
Write-Host
Write-Host "RESULT"
Write-Host "Selected File: $selectedFileName;"
Write-Host
Write-Host "Newly activated services: "
Write-Host

if($outputArrAct.Count -eq 0){
    Write-Host "No active service is absent from the selected snapshot."
	Write-Host
	Write-Host
	
}
else{
	$actResult = $outputArrAct | Out-String
	Write-Host $actResult
	Write-Host
	Write-Host
}
Write-Host "Services stopped from selected snapshot: "
Write-Host
if($outputArrStop.Count -eq 0){
	Write-Host "No services were stopped from the selected snapshot."
}
else{
	$stopResult = $outputArrStop | Out-String
	Write-Host $stopResult
	Write-Host
	Write-Host
}
pause

