###
# Written By: Jason Whittle
# Version: 1.0
# Description: XML update script

<#
.SYNOPSIS
    This script updates an XML file by modifying specific elements and attributes.
.DESCRIPTION
    The script contains several functions to perform different tasks:
    - Write-Log: Writes a log entry to a specified log file.
    - Backup-File: Creates a backup of a file.
    - Update-ExactaAutomationService: Updates the XML file by modifying specific elements and attributes.
    - Stop-ExactaServices: Stops services that start with 'Exacta'.
    - main: The main function that orchestrates the execution of the script.
#>

function Write-Log {
    param (
        [string]$Message,
        [string]$LogPath = "C:\Temp\script.log"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"

    Add-Content -Path $LogPath -Value $logEntry
}

function Backup-File {
    param (
        [string]$FilePath,
        [string]$BackupPath
    )
    #check if the file exists
    if (-not (Test-Path -Path $FilePath)) {
        Write-Log -Message "Checking for Previous Backup: $FilePath Not Found"
        
        # Create a backup of the file
        Copy-Item -Path $FilePath -Destination $BackupPath -Force

        # Verify that the backup file exists
        $backupFileExists = Test-Path -Path $BackupPath

        # Return the status
        if ($backupFileExists) {
            return "SUCCESS"
        } else {
            return "FAILED"
        }
    }else{
        Write-Log -Message "Checking for Previous Backup: $FilePath Found"
        Write-Host "Previous Backup Exist!! please Verify $FilePath" -ForegroundColor Red
        Write-Host "__________________________________________________________________________________" -ForegroundColor Red
        Write-Host "This script will create a backup file of the config, but it there is a backup preexisting the script will not continue." -ForegroundColor Yellow
        Write-Host "Please Remove or Rename $FilePath and rerun the script" -ForegroundColor Yellow
        return "Failed"
    }


    # Create a backup of the file
    Copy-Item -Path $FilePath -Destination $BackupPath -Force

    # Verify that the backup file exists
    $backupFileExists = Test-Path -Path $BackupPath

    # Return the status
    if ($backupFileExists) {
        return "SUCCESS"
    } else {
        return "FAILED"
    }
}

function Update-ExactaAutomationService {
    param (
        [string]$filePath,
        [string]$backupPath
    )

    # Add in a check to see if Exacta services are running 

    # Load the XML file
    $xml = [xml](Get-Content $filePath)
    Write-Log -Message "Loaded XML file: $filePath"
    # Find all elements with a 'key' attribute
    $elements = $xml.configuration.wcfServices.services.add | Where-Object { $_.key }
    Write-Log -Message "Found $($elements.Count) elements with a 'key' attribute in the XML file"
    foreach ($element in $elements) {
        Write-Log -Message "Processing element with key: $($element.key)"
        # Check if maxReceivedMessageSize attribute exists
        if ($element.maxReceivedMessageSize) {
            Write-Log -Message "maxReceivedMessageSize attribute exists in element with key: $($element.key)"
            # Update the maxReceivedMessageSize attribute value
            $element.maxReceivedMessageSize = "2147483647"
        } else {
            Write-Log -Message "maxReceivedMessageSize attribute does not exist in element with key: $($element.key)"
            # Add maxReceivedMessageSize attribute
            $element.SetAttribute("maxReceivedMessageSize", "2147483647")
        }
    }

    # Save the updated XML back to the file
    Write-Log -Message "Saving updated XML file: $filePath"
    $xmlWriterSettings = New-Object System.Xml.XmlWriterSettings
    $xmlWriterSettings.Indent = $true
    $xmlWriterSettings.NewLineOnAttributes = $true

    $xmlWriter = [System.Xml.XmlWriter]::Create($filePath, $xmlWriterSettings)
    $xml.Save($xmlWriter)
    $xmlWriter.Close()
}

function Stop-ExactaServices {
    # Get all services that start with 'Exacta'
    Write-Log -Message "Getting services that start with 'Exacta'"
    $services = Get-Service | Where-Object { $_.Name -like 'Exacta*' }

    # Stop each service and verify it is stopped
    foreach ($service in $services) {
        Write-Log -Message "Stopping service: $($service.Name)"
        Stop-Service -Name $service.Name
        do {
            Write-Log -Message "Waiting for service to stop: $($service.Name)"
            Start-Sleep -Milliseconds 500
            $serviceStatus = Get-Service -Name $service.Name
        } while ($serviceStatus.Status -ne 'Stopped')

        # Log the service stop
        Write-Log -Message "Stopped service: $($service.Name)"
    }
}

function main {
    # Stop the Exacta services
    Write-Log -Message "Stopping Exacta services"
    Stop-ExactaServices

    # Update the ExactaAutomationService configuration
    $filePath = "C:\Users\whitt\Downloads\ExactaWCFService.config"
    $backupPath = "C:\Users\whitt\Downloads\ExactaWCFService.config.bak"

    Write-Log -Message "Creating backup of configuration file"
    $backupStatus = Backup-File -FilePath $filePath -BackupPath $backupPath
    
    if ($backupStatus -eq "SUCCESS") {
        Write-Log -Message "Updating ExactaAutomationService configuration"
        Update-ExactaAutomationService -filePath $filePath -backupPath $backupPath
    } else {
        Write-Log -Message "Failed to create backup of configuration file"
        Write-Host "Failed to create backup of configuration file" -ForegroundColor Red
    }
  

    # Start the Exacta services
    Write-Log -Message "Starting Exacta services"
    Start-Service -Name "Exacta*"
}

main
