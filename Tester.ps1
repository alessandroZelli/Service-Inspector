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
   Write-Host "$i - $filelist[$i]" 
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
    $oldNameList.Add($itemName) | out-null
}
#Write-Host $oldNameList #Optional, used for debug

Write-Host "Service List acquired from csv"
Write-Host
Write-Host
Write-Host
$newServList=@(Get-Service | Where-Object {$_.Status -eq 'running'})
$outputArr=[System.Collections.ArrayList]::new()


Write-Host  "Testing..."

#Tests wether the new service names are contained in the old list, if not, saves them to the output list.
foreach ($j in $newServList){
$newName=$j.Name
if (-not($oldNameList.Contains($newName)))
{
    $outputArr.Add($newName) | Out-Null
       
   }
}

pause
Write-Host
Write-Host
Write-Host
if($outputArr.Count -eq 0){
    write-host "No active service is absent from the master list"
}
else{
Write-Host "Newly activated services: "
Write-Host
Write-Host
Write-Host $outputArr
pause
}

