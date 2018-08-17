#Imports service list and saves it as the Master List or current day's list.
$serviceListArr=@(Get-Service | Where-Object {$_.Status -eq 'running'}) #List of active services
$filePath="C:\ServiceInspector\" #Folder in which the .csv file with the lists are saved
$todaysDate = Get-Date -UFormat "%Y-%m-%d"
$todaysDateHumanFriendly =  Get-Date -DisplayHint Date

#Declaration of filepaths to be used

$filePathMaster = $filePath+"MasterServiceList.csv"
$filePathBackup = $filePath+"MasterServiceList_"+$todaysDate+".csv.old" #Ex. MasterServiceList_2018-07-25.csv.old
$filePathTemp = $filePath+$todaysDate+"_"+"ServiceListUpdate.csv" #Ex. 2018-07-25_ServiceList.csv


Write-Host
Write-Host "Service List on $todaysDateHumanFriendly"
pause
Write-Host
Write-Host
Write-Host
# $serviceListArr #optional code to return the new list to screen
Write-Host
Write-Host
Write-Host

if(-not(Test-Path -Path $filePath)){
    #Creates the master folder if not existent
    Write-Host  "Cartella $filePath assente, procedo alla creazione" 
    mkdir $filePath | Out-Null
    Write-Host
    Write-Host
    Write-Host "Cartella $filePath creata"
    Write-Host
    Write-Host
}



#Asks if you want to save a file called  filePathTemp (see example)
$tempPromptString = "Save the service list of "+ $todaysDateHumanFriendly +"? (y/n)"
Write-Host
Write-Host
$tempUpdateController=Read-Host -prompt  $tempPromptString 
if($tempUpdateController.ToLower() -eq 'y'){
    
    $serviceListArr | Select-Object -Property name,DisplayName,status | Export-csv -Path $filePathTemp -delimiter ';' -NoTypeInformation
    Write-host "Services saved"
    Write-Host
    Write-Host
    
}

#Checks wether the masterlist exists, outputs a prompt to choose wether to update it or not; if non-existent it's created in  $filePath(Master)
if (Test-Path -Path $filePathMaster){
    
    $masterlistUpdateController=Read-Host -prompt  'Update the masterlist? (y/n)'
	
    if($masterlistUpdateController.ToLower() -eq 'y'){
        #when the masterlist is updated the old one is saved in $filePathBackup as a .csv.old file
        Write-Host
        Write-Host
        copy-item $filePathMaster -Destination $filePathBackup
        Write-Host
        Write-Host "Backup created in $filePathBackup"
        Write-Host
        $serviceListArr | Select-Object -Property name,DisplayName,status | Export-csv -Path $filePathMaster -delimiter ';' -NoTypeInformation
        Write-Host 'Master List Updated'
    }
    else{
        exit
    }
}else{
  $serviceListArr | Select-Object -Property name,DisplayName,status | Export-csv -Path $filePathMaster -delimiter ';' -NoTypeInformation  
  Write-Host "Master List Created"
  pause
}

