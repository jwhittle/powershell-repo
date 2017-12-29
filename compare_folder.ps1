$dir1 = 'C:\Users\jwhittle\Desktop\WS01\WS01\'
$dir2 = 'C:\Users\jwhittle\Desktop\WS01\WS11\'
$Exclude = @("*.txt", "*.InstallLog")
$d1 = get-childitem -path $dir1 -Recurse -Exclude $Eliminate #| ? {$_.FullName -inotmatch 'log*' }
$d2 = get-childitem -path $dir2 -Recurse -Exclude $Eliminate #| ? {$_.FullName -inotmatch 'log*' }
Write-Host "Number of files to check:" $d1.count
<#echo "$dir1\$d1"#>
foreach($file in $d1){
    #echo "$dir1$file"
    $prod = "$dir1$file"
    $bak = "$dir2$file"
    #echo $prod
    #echo $bak
    #echo $(get-content "$prod")
    #echo $(get-content "$bak")

    if(Compare-Object $(get-content "$prod") $(get-content "$bak")){
        echo $prod" --- File OUT of sync"
    }Else{
       #echo $file
       # "File IN SYNC"
    }
}
