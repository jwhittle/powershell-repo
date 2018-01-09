
$RemoteComputers = @("172.16.48.173","PC2")
ForEach ($Computer in $RemoteComputers){
    If (Test-Connection -ComputerName $Computer -Quiet)
    {
        Write-Host "OK!'
        #Invoke-Command -ComputerName $Computer -ScriptBlock {Get-ChildItem “C:\Program Files\Bastian Solutions\Exacta\Stop Exacta Services.bat”}
        
    }
}