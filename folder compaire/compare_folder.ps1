$dir1 = 'C:\Users\jwhittle\Desktop\WS01\WS01\'
$dir2 = 'C:\Users\jwhittle\Desktop\WS01\WS11\'



function Get-Compare_File_Version{
    param(
        [string]$prod,
        [string]$bak
    )
    

    $prod_ver = & '..\bin\sigcheck.exe' "-nobanner" "-n" $prod
    $bak_ver = & '..\bin\sigcheck.exe' "-nobanner" "-n" $bak

    if(Compare-Object $prod_ver $bak_ver){
        $out = "<TD>$prod_ver</td><td>$bak_ver</TD>"
    }Else{
        $out = "<TD colspan='2'>$prod_ver</TD>"
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

if (Test-Path report.html){Remove-Item report.html}


#create HTML
Add-Content 'report.html' '<HTML><BODY>'
Add-Content 'report.html' "<CENTER>Report of file comparison of <BR><a href='file://$dir1'>$dir1</a> <BR> and <BR><a href='file://$dir2'>$dir2</a></CENTER>"

#File types to exclude
$d1 = get-childitem -File -path $dir1  -Recurse `
    | Where-Object {`
        #$_.Extension -notlike ".dll" -and `
        $_.Extension -notlike ".pdb"}

#Add-Content 'report.html' "Number of files to compared $d1.count"

#table Header
Add-Content 'report.html' '<CENTER><TABLE border="1">'
Add-Content 'report.html' '<TH>FILE</TH>'
Add-Content 'report.html' '<TH colspan="2">version</TH>'
Add-Content 'report.html' '<TH>STATUS</TH>'
Add-Content 'report.html' '<TH>move command</TH>'

#table data
foreach($file in $d1){
    #write-host $file
    $prod = "$dir1$file"
    $bak = "$dir2$file"
    
    $ver = Get-Compare_File_Version -prod $prod -bak $bak
    $match = Get-Compare_File -prod $prod -bak $bak
    if ($ver -Or $match){Add-Content 'report.html' "<TR><TD>$file</TD><TD>$ver</TD><TD>$match</TD></TR>"} 
    Add-Content 'report.html' "<TR><TD>$file</TD>$ver<TD>$match</TD>"
    if ($match){Add-Content 'report.html' "<TD><code>COPY $prod $bak</code></TD>"}
    else{Add-Content 'report.html' "<TD></TD>"}
    Add-Content 'report.html' "<TR>"
}
#ending tags for the table
Add-Content 'report.html' "</TABLE></body></HTML>"

#open the report
Invoke-Item report.html

