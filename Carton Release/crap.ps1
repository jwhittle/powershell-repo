$file = 'C:\Users\jwhittle\Desktop\powershell-repo\Carton Release\Carton Release.txt'
$carton = ''
$data = Get-Content $file

#07:33:26.537 [1] INFO  Equipment 5 - 07:33:26:537 - SCAN  Queued UP For Scanner Carton PandA Verif TIME START  $Queued_up[5]
#07:33:26.611 [1] INFO  Equipment 5 - 07:33:26:611 - GOOD Match at Carton PandA Verif. Barcode1 C7DT8ZI6I3F Barcode2 C7DT8ZI6I3 - [07:33:26:565]  $Good_match[6]
#07:33:26.623 [1] INFO  Equipment 5 - 07:33:26:623 - Posting Process Scan results for Scanner Carton PandA Verif to controls for package tracking id - 98, barcode - C7DT8ZI6I3, destination - 99. $Post_[5]
$matches = @{


}


$start_line = @()
$counter = 0
foreach ($line in $data){
    if ($line -match "SCAN  Queued UP For Scanner Carton PandA Verif TIME START"){
        $Start_time_patern = " - (.*) - SCAN"
        $Start_time = [regex]::Match($line, $Start_time_patern).Groups[1].Value
        
        $sub_lines = 1
        $end = 10
        write-host "$counter $Start_time"
        DO{            
            $next_entry_num = $counter + $sub_lines
            $next_entry = $data[$next_entry_num]
            if ($next_entry -match "GOOD Match at Carton PandA Verif. Barcode1"){###
                #pull time, and barcode1, barcode2
                $write = 'Y'
                $verify_time
            }elseif($next_entry -match " - Barcode Mismatch at Carton PandA Verif. Barcode1 "){##
                #pull time and ID
                $write = 'Y'
            }elseif($next_entry -match " - Posting Process Scan results for Scanner Carton PandA Verif to controls for package tracking id - "){
                #pull time and ID
                $write = 'Y'
            }else{
                $write ='N'
        }
        if ($write -eq 'Y'){
            write-host "$next_entry"
        }
            
            
            
            
            


            $sub_lines++
        } While ($sub_lines -le $end)




        
        $next_entry = $data[$next_entry_num]
        if ($next_entry -match "GOOD Match at Carton PandA Verif. Barcode1"){###
            #pull time, and barcode1, barcode2
            $write = 'N'
        }elseif($next_entry -match "Found Request for Activity Tracking AUTOMATION "){
            #pull time and ID
            $write = 'N'
        }elseif($next_entry -match "Ready to Process Request Barcode "){
            #pull time and ID
            $write = 'N'
        }elseif($next_entry -match "Detected no read at Carton PandA Verif. Barcode1 "){
            #pull time and ID
            $write = 'N'
        }elseif($next_entry -match " - Route Container "){
            #pull time and ID
            $write = 'N'
        }elseif($next_entry -match " has been updated to released status - "){
            #pull time and ID
            $write = 'N'
        }elseif($next_entry -match "Beginning to update status for container "){
            #pull time and ID
            $write = 'N'
        }elseif($next_entry -match " Queued UP For Scanner Carton PandA TIME START"){
            #pull time and ID
            $write = 'N'
        }elseif($next_entry -match " - Updating container "){
            #pull time and ID
            $write = 'N'
        }elseif($next_entry -match " - Container Name "){
            #pull time and ID
            $write = 'N'
        }elseif($next_entry -match " - Barcode Mismatch at Carton PandA Verif. Barcode1 "){##
            #pull time and ID
            $write = 'N'
         }elseif($next_entry -match " - Looking for Released Carton with Carton Type "){
            #pull time and ID
            $write = 'N'
        }else{
            $write ='Y'
        }
        
        
        
        
        if ($write -eq 'Y'){
        
            #write-host "$counter $Start_time - $next_entry"
        }
        
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
    $counter++
}












######

#$F = 
##Select-String -Path $file -Pattern "Ready to Process Request Barcode" -Context 0, 3 
#| %{$data = $_.Split('-'); Write-host "'$($data[0])'"}

#$F.count
#($F)[0].context clear