
###

function Write-Log {
    param (
        [string]$Message,
        [string]$LogPath = "C:\Temp\script.log"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"

    Add-Content -Path $LogPath -Value $logEntry
}

function Update-ExactaAutomationService {
    param (
        [string]$filePath,
        [string]$backupPath
    )

    # Add in a check to see if Exacta services are running 

    # Create a backup of the file
    Copy-Item -Path $filePath -Destination $backupPath -Force

    # Load the XML file
    $xml = [xml](Get-Content $filePath)

    # Find all elements with a 'key' attribute
    $elements = $xml.configuration.wcfServices.services.add | Where-Object { $_.key }

    foreach ($element in $elements) {
        # Check if maxReceivedMessageSize attribute exists
        if ($element.maxReceivedMessageSize) {
            # Update the maxReceivedMessageSize attribute value
            $element.maxReceivedMessageSize = "2147483647"
        } else {
            # Add maxReceivedMessageSize attribute
            $element.SetAttribute("maxReceivedMessageSize", "2147483647")
        }
    }

    # Save the updated XML back to the file
    $xmlWriterSettings = New-Object System.Xml.XmlWriterSettings
    $xmlWriterSettings.Indent = $true
    $xmlWriterSettings.NewLineOnAttributes = $true

    $xmlWriter = [System.Xml.XmlWriter]::Create($filePath, $xmlWriterSettings)
    $xml.Save($xmlWriter)
    $xmlWriter.Close()
}

function Stop-ExactaServices {
    # Get all services that start with 'Exacta'
    $services = Get-Service | Where-Object { $_.Name -like 'Exacta*' }

    # Stop each service and verify it is stopped
    foreach ($service in $services) {
        Stop-Service -Name $service.Name
        do {
            Start-Sleep -Milliseconds 500
            $serviceStatus = Get-Service -Name $service.Name
        } while ($serviceStatus.Status -ne 'Stopped')

        # Log the service stop
        Write-Log -Message "Stopped service: $($service.Name)"
    }
}

function main {
    # Stop the Exacta services
    Stop-ExactaServices

    # Update the ExactaAutomationService configuration
    $filePath = "C:\Users\whitt\Downloads\ExactaWCFService.config"
    $backupPath = "C:\Users\whitt\Downloads\ExactaWCFService.config.bak"
    Update-ExactaAutomationService -filePath $filePath -backupPath $backupPath

    # Start the Exacta services
    Start-Service -Name "Exacta*"

    # Log the start of the services
    Write-Log -Message "Started Exacta services"
}

main

