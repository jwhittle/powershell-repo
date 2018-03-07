$file = 'C:\Users\jwhittle\Desktop\powershell-repo\Carton Release\Carton Release.txt'
$carton = ''
$data = Get-Content $file

#07:33:26.537 [1] INFO  Equipment 5 - 07:33:26:537 - SCAN  Queued UP For Scanner Carton PandA Verif TIME START  $Queued_up[5]
#07:33:26.611 [1] INFO  Equipment 5 - 07:33:26:611 - GOOD Match at Carton PandA Verif. Barcode1 C7DT8ZI6I3F Barcode2 C7DT8ZI6I3 - [07:33:26:565]  $Good_match[6]
#07:33:26.623 [1] INFO  Equipment 5 - 07:33:26:623 - Posting Process Scan results for Scanner Carton PandA Verif to controls for package tracking id - 98, barcode - C7DT8ZI6I3, destination - 99. $Post_[5]




foreach ($line in $data){
    #slect-String -Path $line -Pattern "Ready to Process Request Barcode"

    if ($line -match "SCAN  Queued UP For Scanner Carton PandA Verif TIME START"){
        

        #Ready to Process parse -> $container_id
        ##Pull container ID
        $Start_time_patern = " - (.*) - GOOD "
        $Start_time = [regex]::Match($line, $container_id_patern).Groups[1].Value
        
        ##Pull actual time - $time
        #$time_patern = "- \[(.*)\]"
        #$time = [regex]::Match($line, $time_patern).Groups[1].Value 
        #$time = $time -replace "(.*):(.*)", '$1.$2'
       
        ##Convert $time into TIME
        #$provider = New-Object System.Globalization.CultureInfo "en-US"
        #$dateTime = [datetime]::ParseExact($time, 'HH:mm:ss.fff', $provider)
        #$dateTime = $dateTime -F 'HH:mm:ss.fff'
        
        #$dateTime = Get-Date "03/02/2018 $time"
        
        
        
        
#        if ($container_id -ne ''){    
##            if ($container_id -eq '?'){$container_id = 'NO READ!!!'}
#            
#            $start_time = '03/02/2018 12:00:00.00'
#            $diff = NEW-TIMESPAN –Start $Start_time –End $dateTime
#            #write-host "$diff"
##            write-host "DIFF: $diff - CONTAINER: $container_id - TIME",$time
#            




#            $count = $data.IndexOf($line)
#            $count = $count + 1
#            #write-host "$line"
#            $found_in_memory = $data[$count]
#            # ##Pull actual time - $time
#            $time_patern = "- \[(.*)\]"
#            
#            $found_in_memory_time = [regex]::Match($found_in_memory, $time_patern).Groups[1].Value 
#            $found_in_memory_time = $found_in_memory_time -replace "(.*):(.*)", '$1.$2'
#            write-host "In Memory:                                    $found_in_memory_time"#
#
#
#
#            $seconds1 = ([TimeSpan]::Parse($time)).TotalMilliseconds
#            $seconds2 = ([TimeSpan]::Parse($found_in_memory_time)).TotalMilliseconds
#
#            $diff = $seconds2 - $seconds1
#            
#    
#            write-host "Diff:                                         $diff" 



#        }
        
    }
}












######

#$F = 
##Select-String -Path $file -Pattern "Ready to Process Request Barcode" -Context 0, 3 
#| %{$data = $_.Split('-'); Write-host "'$($data[0])'"}

#$F.count
#($F)[0].context clear