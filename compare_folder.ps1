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
        $out = "$prod_ver / $bak_ver"
    }Else{
        $out = "$prod_ver / $bak_ver"
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



if (Test-Path report.html) 
{
  Remove-Item report.html
}



Add-Content 'report.html' '<HTML><BODY>'
Add-Content 'report.html' "<CENTER><H1>Report of file comparison of <BR>
$dir1 <BR> and <BR> 
$dir2
<H1></CENTER>
"
$d1 = get-childitem -path $dir1 -Recurse -Exclude $Eliminate #| ? {$_.FullName -inotmatch 'log*' }
$d2 = get-childitem -path $dir2 -Recurse -Exclude $Eliminate #| ? {$_.FullName -inotmatch 'log*' }



#Add-Content 'report.html' "Number of files to compared $d1.count"
Add-Content 'report.html' '<CENTER><TABLE border="1"><TH>FILE</TH><TH>version</TH><TH>STATUS</TH>'
<#echo "$dir1\$d1"#>

foreach($file in $d1){

    $prod = "$dir1$file"
    $bak = "$dir2$file"
    
    $ver = Get-Compare_File_Version -prod $prod -bak $bak
    $match = Get-Compare_File -prod $prod -bak $bak
    #if ($ver -Or $match){Add-Content 'report.html' "<TR><TD>$file</TD><TD>$ver</TD><TD>$match</TD></TR>"} 
    Add-Content 'report.html' "<TR><TD>$file</TD><TD>$ver</TD><TD>$match</TD></TR>"

}
Invoke-Item report.html

