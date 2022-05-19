#DESCRIPTION: Open logs and tail -f
#Ver: 1.0
#Written by: Jason Whittle


$path = "\\192.168.40.113\l$\Bastian Software\Logs\ExactaPrintServer\"
$filename = Get-ChildItem "\\192.168.40.113\l$\Bastian Software\Logs\ExactaPrintServer\" | sort LastWriteTime | select -last 1

$full_path = $path + $filename
write-host $full_path

#start powershell {
    Get-Content $full_path -Tail 10 -Wait
#    read-host
    
#    }