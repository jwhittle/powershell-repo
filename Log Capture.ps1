<#
.SYNOPSIS
Log Capture for Touch.

.DESCRIPTION
This script captures logs for the Touch application and organizes them into subfolders based on the application name. It then compresses the subfolders into a zip file and copies it to a final destination.

.PARAMETER path_to_logs
A hashtable that maps application names to their corresponding log paths.

.PARAMETER out_folder
The path to the output folder where the logs will be temporarily stored.

.PARAMETER stationName
The name of the current station.

.PARAMETER domain_auth
A flag indicating whether domain authentication is required.

.PARAMETER final_dest
The final destination where the zip file will be copied.

.EXAMPLE
.\Log Capture.ps1
Runs the Log Capture script.

.NOTES
Written by Jason Whittle.
Version: 1.0
#>
## Description: Log capture for Touch
# Written by: Jason Whittle
# Version: 1.0
#TODO
 #Add a flag to disable the copy progress bar
 

###SETTINGS
$path_to_logs = @{
    Touch =       "C:\Bastian Software\Logs\ExactaTouch\"
    Automation  = "C:\ProgramData\Bastian Software\Logs\ExactaAutomationService\"
    'App BatchMonitor' = '\\192.168.40.112\Logs\BatchMonitor\'
    'App CICM' = '\\192.168.40.112\Logs\CICM\'
    'App Cubing' = '\\192.168.40.112\Logs\Cubing\'
    'App EAS' = '\\192.168.40.112\Logs\EAS\'
    'App ExactaAutoStoreTaskReconciliation' = '\\192.168.40.112\Logs\ExactaAutoStoreTaskReconciliation\'
    'App ExactaCycleCountScheduler' = '\\192.168.40.112\Logs\ExactaCycleCountScheduler\'
    'App ExactaEventDirector' = '\\192.168.40.112\Logs\ExactaEventDirector\'
    'App ExactaExport' = '\\192.168.40.112\Logs\ExactaExport\'
    'App ExactaExportAdapter' = '\\192.168.40.112\Logs\ExactaExportAdapter\'
    'App ExactaImport' = '\\192.168.40.112\Logs\ExactaImport\'
    'App ExactaImportAdapter' = '\\192.168.40.112\Logs\ExactaImportAdapter\'
    'App ExactaJobRunner' = '\\192.168.40.112\Logs\ExactaJobRunner\'
    'App ExactaKitting' = '\\192.168.40.112\Logs\ExactaKitting\'
    'App ExactaLightController' = '\\192.168.40.112\Logs\ExactaLightController\'
    #'App ExactaLogFileCollector-1.0.0.5' = '\\192.168.40.112\Logs\ExactaLogFileCollector-1.0.0.5\'
    'App ExactaMobile' = '\\192.168.40.112\Logs\ExactaMobile\'
    'App ExactaNaming' = '\\192.168.40.112\Logs\ExactaNaming\'
    'App ExactaPortal' = '\\192.168.40.112\Logs\ExactaPortal\'
    'App ExactaPreProcessor' = '\\192.168.40.112\Logs\ExactaPreProcessor\'
    #'App ExactaPurgeLog' = '\\192.168.40.112\Logs\ExactaPurgeLog\'
    'App ExactaReceiving' = '\\192.168.40.112\Logs\ExactaReceiving\'
    'App ExactaServiceManagement' = '\\192.168.40.112\Logs\ExactaServiceManagement\'
    #'App ExactaStartupService' = '\\192.168.40.112\Logs\ExactaStartupService\'
    'App ExactaVoice' = '\\192.168.40.112\Logs\ExactaVoice\'
    'App Manifest' = '\\192.168.40.112\Logs\Manifest\'
    'App PackVerify' = '\\192.168.40.112\Logs\PackVerify\'
    'App Putwall' = '\\192.168.40.112\Logs\Putwall\'
    'App Replenishment' = '\\192.168.40.112\Logs\Replenishment\'
    'App ResourceLock' = '\\192.168.40.112\Logs\ResourceLock\'
    'App UserAuthorization' = '\\192.168.40.112\Logs\UserAuthorization\'
    'App WorkAcquire' = '\\192.168.40.112\Logs\WorkAcquire\'
}

$out_folder = "C:\temp"
$stationName = $env:COMPUTERNAME
#$stationName = 'AS07'
$domain_auth = 'N'
$final_dest = '\\LVTS01\Temp logs\'
#####


function Test-Cred {
           
    [CmdletBinding()]
    [OutputType([String])] 
       
    Param ( 
        [Parameter( 
            Mandatory = $false, 
            ValueFromPipeLine = $true, 
            ValueFromPipelineByPropertyName = $true
        )] 
        [Alias( 
            'PSCredential'
        )] 
        [ValidateNotNull()] 
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()] 
        $Credentials
    )
    $Domain = $null
    $Root = $null
    $Username = $null
    $Password = $null
      
    If($Credentials -eq $null)
    {
        Try
        {
            $Credentials = Get-Credential "domain\$env:username" -ErrorAction Stop
        }
        Catch
        {
            $ErrorMsg = $_.Exception.Message
            Write-Warning "Failed to validate credentials: $ErrorMsg "
            Pause
            Break
        }
    }
      
    # Checking module
    Try
    {
        # Split username and password
        $Username = $credentials.username
        $Password = $credentials.GetNetworkCredential().password
  
        # Get Domain
        $Root = "LDAP://" + ([ADSI]'').distinguishedName
        $Domain = New-Object System.DirectoryServices.DirectoryEntry($Root,$UserName,$Password)
    }
    Catch
    {
        $_.Exception.Message
        Continue
    }
  
    If(!$domain)
    {
        Write-Warning "Something went wrong"
    }
    Else
    {
        If ($domain.name -ne $null)
        {
            return "Authenticated"
        }
        Else
        {
            return "Not authenticated"
        }
    }
}

function mk_temp_folder{
    param($out_folder)
    $date = Get-Date -Format "yyyyMMdd HHmm"
    $path_to_temp = $out_folder +"\" +$stationName +" "+$date
    If(!(test-path -PathType container $path_to_temp)){
        New-Item -Path $path_to_temp -ItemType Directory
    }else{
        New-Item -Path $path_to_temp -ItemType Directory -Force
    }
    return $path_to_temp
}

function mk_sub_folders{
    Param($temp_path)
    if ($test -eq 'Y'){Write-host "mk_sub_folders: Path to output" $temp_path}
    foreach ($key in $path_to_logs.keys){
        $folder_to_mk = $temp_path + $key
        If(!($NULL = test-path -PathType container $temp_path)){
            $null = New-Item -Path $folder_to_mk -ItemType Directory
        }else{
           $null = New-Item -Path $folder_to_mk -ItemType Directory -Force
        }
    }

}

function mv_logs_to_sub_folders{
    Param($temp_path)
    foreach ($key in $path_to_logs.keys){
        $folder_to_mk = $temp_path + $key
        $files = gci $path_to_logs[$key] | sort LastWriteTime |select -last 3
        foreach ($file in $files){
            $full_path = $path_to_logs[$key] + $file
            $dest = $temp_path + $key + '\'
            If((test-path -PathType container $dest )){Copy-Item -Path $full_path -Destination $dest -Recurse}else{
                write-host "Folder does not Exist"
            }
        }

    }
}

function Copy-File {
    param( [string]$from, [string]$to)
    $ffile = [io.file]::OpenRead($from)
    $tofile = [io.file]::OpenWrite($to)
    Write-Progress -Activity "Copying file" -status "$from -> $to" -PercentComplete 0
    try {
        [byte[]]$buff = new-object byte[] 4096
        [long]$total = [int]$count = 0
        do {
            $count = $ffile.Read($buff, 0, $buff.Length)
            $tofile.Write($buff, 0, $count)
            $total += $count
            if ($total % 1mb -eq 0) {
                Write-Progress -Activity "Copying file" -status "$from -> $to" `
                   -PercentComplete ([long]($total * 100 / $ffile.Length))
            }
        } while ($count -gt 0)
    }
    finally {
        $ffile.Dispose()
        $tofile.Dispose()
        Write-Progress -Activity "Copying file" -Status "Ready" -Completed
    }
}
    

function make_note{}

function zip{
    Param($temp_path)
    $zip_out = $temp_path + '.zip'
    if ($test -eq 'Y'){write-host "zip:      $temp_path Full Destination:" $zip_out}
    Compress-Archive -Path $temp_path -DestinationPath  $zip_out
    return $zip_out
}

function main{
    cls
    if ($domain_auth -eq 'Y'){
        $CredCheck = $Credentials  | Test-Cred
            If($CredCheck -ne "Authenticated"){
            Write-Warning "Credential validation failed"
            pause
            Break
        }
    }
    $temp_path = mk_temp_folder -out_folder $out_folder
    $temp_pathWOSlash = [string]$temp_path[0]
    $temp_path_withSlash = [string]$temp_path[0] + '\' #add backslash
    mk_sub_folders -temp_path $temp_path_withSlash
    mv_logs_to_sub_folders -temp_path $temp_path_withSlash
    $zip_out = zip -temp_path $temp_pathWOSlash
    Remove-Item $temp_path_withSlash -Recurse -Force
    cls
    write-host $zip_out
    Write-host "Copying .zip to Final $final_dest"
    Copy-File -from $zip_out -to $final_dest
    #Invoke-Item $final_dest
    write-host "Transfer complete Please CLOSE Window"
    Exit

    
}

main
