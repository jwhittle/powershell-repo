$dir1 = 'C:\Users\jwhittle\Desktop\WS01\WS01\'
$dir2 = 'C:\Users\jwhittle\Desktop\WS01\WS11\'
$Exclude = @("*.txt", "*.InstallLog")


function Get-Compare_File_Version{
    param(
        [string]$prod,
        [string]$bak
    )
    

    $prod_ver = & '.\bin\sigcheck.exe' "-nobanner" "-n" $prod
    $bak_ver = & '.\bin\sigcheck.exe' "-nobanner" "-n" $bak

    if(Compare-Object $prod_ver $bak_ver){
        $out = "Version Miss-Match"
    }Else{
       #echo $file
       # "File IN SYNC"
    }
    if ($out){return $out}

}

function Get-Compare_File{
    param(
        [string]$prod,
        [string]$bak
    )

    #Check files for diff
    if(Compare-Object $(get-content "$prod") $(get-content "$bak")){
        $out = "File OUT of sync"
    }Else{
       #echo $file
       # "File IN SYNC"
    }
    if ($out){return $out}

}








Write-Host "Report of file comparison of 
$dir1 and 
$dir2
"
$d1 = get-childitem -path $dir1 -Recurse -Exclude $Eliminate #| ? {$_.FullName -inotmatch 'log*' }
$d2 = get-childitem -path $dir2 -Recurse -Exclude $Eliminate #| ? {$_.FullName -inotmatch 'log*' }

Write-Host "Number of files to compared" $d1.count
<#echo "$dir1\$d1"#>
foreach($file in $d1){

    $prod = "$dir1$file"
    $bak = "$dir2$file"
    
    $ver = Get-Compare_File_Version -prod $prod -bak $bak
    $match = Get-Compare_File -prod $prod -bak $bak
    if ($ver -Or $match){Write-Host "$file $ver | $match"} 


}


