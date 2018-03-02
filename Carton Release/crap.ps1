#$data = Get-Content 'C:\Users\jwhittle\Desktop\c_r_a_p\Carton Release.txt'


#foreach ($line in $data){
    #Select-String -Path $line -Pattern "Ready to Process Request Barcode"
    #Write-host "$line"
#}

#$F = 
Select-String -Path 'C:\Users\jwhittle\Desktop\c_r_a_p\Carton Release.txt' -Pattern "Ready to Process Request Barcode" -Context 0, 3 
#| %{$data = $_.Split('-'); Write-host "'$($data[0])'"}

#$F.count
#($F)[0].context clear