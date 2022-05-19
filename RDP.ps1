function RDP{
     Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Server,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $User,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $Password
    ) 
    $Port="49982"

    mstsc.exe /v:$Server /user $User /Password $Password

}

RDP -Server "192.168.126.18" -User "Administrator" -Password "Bss1234"