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


$ip_list = @()                                                #create the blank array of ips
foreach ($line in $data){
    if (($line -like '*bingbot*') -and ($line -notlike '* 200 0 0 *')){  #look form lines With Bingbot and igore lines that end with '200 0 0'
        $ip_patern = " - 443 Anonymous (.*) Mozilla/5.0"                 #how do I find the ip
        $ip = [regex]::Match($line, $ip_patern).Groups[1].Value          #extract the ip
        if ($ip -ne ''){                                                 #clean up
            $octet = $ip.Split('.')                                      #get the 1st octet from the ip
            if ($octet[0] -ne '10'){                                     #ignore the 10.
                $ip_list += $ip                                          #add it to the array
            }
        }
    }
}


$ip_list = $ip_list | Sort-Object | Get-Unique                           #get unique ips
#write-host $ip_list
foreach ($ip in $ip_list){                                               #write them out
    write-host "|$ip|"
    Add-Content $log "$ip"
}