
function OpenLogsOnStation {
Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $hostname,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $path
    )
    if (Test-Connection $hostname -Quiet) 
    { 
        invoke-item "\\$hostname\$path" 
    } 
    else 
    {
        Write-Host "$hostname FAILED" 
    }
}



function SearchForString {
    #Search for string inside of a log file...
    #set the path to the logs folder of your choice,  and it will search the logs that are less than X hours old.
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $string_data,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $path
    )
    write-host "$string_data"
    $data = Get-ChildItem -path $path -Recurse| where {$_.Lastwritetime -lt (date).addhours(-48)} #| Select-String -Pattern $string_data -AllMatches  | Foreach {$_.Line}
    #$data = Select-String -Path $path -Pattern $string_data -AllMatches  | Foreach {$_.Line}
    $data
    return
}





#OpenLogsOnStation -hostname '192.168.41.60' -path 'C$'


OpenLogsOnStation -hostname '192.168.41.80' -path 'C$'
#OpenLogsOnStation -hostname '192.168.42.9' -path 'C$'
