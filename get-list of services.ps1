
cls
function services{
    $services = Get-Service "exacta*"
    foreach ($service in $services){
        write-host "<service>"
        write-host "     <name>"$service.Name"</name>"
        write-host "     <DisplayName>"$service.DisplayName"</DisplayName>"
        write-host "</service>"
    }
}
function log_dirs{
    cls
    $paths = @("C:\ProgramData\Bastian Software\Logs","C:\ProgramData\Bastian Software\Logs")
    foreach ($path in $paths){
        $log_dirs = Get-ChildItem $path –recurse -directory
        foreach ($log_dir in $log_dirs){
        write-host "<log>"
        write-host "     <name>$log_dir</name>"
        write-host "     <path-to-folder>"$log_dir.fullName"</path-to-folder>"
        write-host "</log>"
        }

    }
}


log_dirs

