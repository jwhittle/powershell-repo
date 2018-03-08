$a = 'C:\Users\jwhittle\Desktop\listip.txt'

$b = Get-Content $a | Sort-Object -Unique

foreach ($out in $b){
    write-host $out
}