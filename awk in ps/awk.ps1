#parse it out to screen
Get-Content .\test.txt | %{$data = $_.Split('-'); Write-Host "update loc_master set zone_num = '10' where zone_num = '$($data[0])' and ROW_num = '$($data[1]) and BAY_NUM = '$($data[2])' SHELF_NUM ='$($data[3])' CELL_NUM ='$($data[4])'" }


#parse out to txt file
Get-Content .\test.txt | %{$data = $_.Split('-'); Add-Content 'output.txt' "update loc_master set zone_num = '10' where zone_num = '$($data[0])' and ROW_num = '$($data[1]) and BAY_NUM = '$($data[2])' SHELF_NUM ='$($data[3])' CELL_NUM ='$($data[4])'" }