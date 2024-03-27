$remotePC = "10.200.1.223"


try {
    # Prompt user for credentials
    $credentials = Get-Credential

    # Create a new PSsession to the remote PC with credentials
    $session = New-PSSession -ComputerName $remotePC -Credential $credentials

    # Check if the session is open
    if ($session.State -eq "Opened") {
        Write-Host "Session opened successfully."
    } else {
        Write-Host "Failed to open session."
    }
} catch {
    Write-Host "Error occurred while opening session: $_"
} finally {
    # Close the PSsession
    if ($session) {
        Remove-PSSession -Session $session
    }
}
