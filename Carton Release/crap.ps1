$file = 'C:\Users\jwhittle\Desktop\powershell-repo\Carton Release\Carton Release.txt'
$carton = ''
$data = Get-Content $file





foreach ($line in $data){
    #slect-String -Path $line -Pattern "Ready to Process Request Barcode"

    if ($line -match "Ready to Process Request Barcode"){
        

        #Ready to Process parse -> $container_id
        ##Pull container ID
        $container_id_patern = "Ready to Process Request Barcode (.*) Track Id"
        $container_id = [regex]::Match($line, $container_id_patern).Groups[1].Value
        
        ##Pull actual time - $time
        $time_patern = "- \[(.*)\]"
        $time = [regex]::Match($line, $time_patern).Groups[1].Value 
        

        ##Convert $time into TIME
        $provider = New-Object System.Globalization.CultureInfo "en-US"
        $dateTime = [datetime]::ParseExact($time, 'HH:mm:ss:fff', $provider)
        $dateTime = $dateTime -F 'HH:mm:ss:fff'
        
        
        
        
        
        if ($container_id -ne ''){    
            if ($container_id -eq '?'){$container_id = 'NO READ!!!'}
            
            $start_time = '03/02/2018 12:00:00'
            $diff = NEW-TIMESPAN –Start $Start_time –End $dateTime
            #write-host "$diff"
            write-host "$diff - $container_id - ",$time
            
            #write-host $line



            $count = $data.IndexOf($line)
            $count = $count + 2
            #write-host "$line"
            #write-host "2 LINES BELOW  $data[$count]"
        }







 

    }
}












######

#$F = 
##Select-String -Path $file -Pattern "Ready to Process Request Barcode" -Context 0, 3 
#| %{$data = $_.Split('-'); Write-host "'$($data[0])'"}

#$F.count
#($F)[0].context clear