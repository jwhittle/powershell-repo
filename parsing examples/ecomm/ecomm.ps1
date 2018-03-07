#Decription:  Ecomm logs parsing
#Date: 3/7/2018
#Version: 1.0
#Requirements
##1. Parse logs and find Occurrences of "bingbot"
##2. Extract the ip address from the string in requirment 1.
##3. Ignore all lines from requirement 1.  that contain "200" at the end of the line.
##4. Write-out a list of unique ips meeting the conditions from requirments 1,2,3




$file = 'C:\Users\jwhittle\Desktop\powershell-repo\parsing examples\ecomm\u_ex180223.log'
$log =  'C:\Users\jwhittle\Desktop\powershell-repo\parsing examples\ecomm\output.txt'
$data = Get-Content $file


$ip_list = @()
foreach ($line in $data){
    if ($line -like '*bingbot*'){
        if ($line -notlike '* 200 0 0 *'){
            #Write-host "$rline"
        
        
            $split = $line.Split('-') 
        
            #Add-Content $log "$line"
            $ip_patern = " - 443 Anonymous (.*) Mozilla/5.0"
            $ip = [regex]::Match($line, $ip_patern).Groups[1].Value
            #write-host "$ip"
            if ($ip -ne ''){
                $octet = $ip.Split('.')
                if ($octet[0] -ne '10'){
                    $ip_list += $ip
                }
            }
            #write-host $split[1]
        }
    }
}


$ip_list = $ip_list | Sort-Object | Get-Unique
#write-host $ip_list
foreach ($ip in $ip_list){


    write-host "|$ip|"
}