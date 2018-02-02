#Written By: Jason Whittle
#version: 2.0


###### paramaters

$dir1 = 'C:\Users\jwhittle\Desktop\WS01\WS01\'
$dir2 = 'C:\Users\jwhittle\Desktop\WS01\WS11\'

$get_diff = 'Y'  #keep set to N unless you need to compaire files by checksum.  WARNING this will slow the script...   ALOT!!
######

#functions

function IsAscii([System.IO.FileInfo]$item){
    begin 
    { 
        $validList = new-list byte
        $validList.AddRange([byte[]] (10,13) )
        $validList.AddRange([byte[]] (31..127) )
    }

    process
    {
        try 
        {
            $reader = $item.Open([System.IO.FileMode]::Open)
            $bytes = new-object byte[] 1024
            $numRead = $reader.Read($bytes, 0, $bytes.Count)

            for($i=0; $i -lt $numRead; ++$i)
            {
                if (!$validList.Contains($bytes[$i]))
                    { return $false }
            }
            $true
        }
        finally
        {
            if ($reader)
                { $reader.Dispose() }
        }
    }
}


function Get-Compare_File_Version{
    param([string]$prod,[string]$bak)
    $ver_sync = @{}
    $prod_ver = & '.\bin\sigcheck.exe' "-nobanner" "-n" $prod
    $bak_ver =  & '.\bin\sigcheck.exe' "-nobanner" "-n" $bak

    $ver_sync.Add('prod_ver',$prod_ver)
    $ver_sync.Add('qa_ver',$bak_ver)

    if(Compare-Object $prod_ver $bak_ver){
        $ver_sync.Add('ver_sync','N') 
    }Else{
        $ver_sync.Add('ver_sync','Y') 
    }
    return $ver_sync

}

function Get-Compare_File{
    param([string]$prod,[string]$bak)

    #Check files for diff
    if(Compare-Object $(get-content "$prod") $(get-content "$bak")){
        $diff = 'N' 
    }Else{
        $diff = 'Y' 
    }
    return $diff

}




$d1 = get-childitem -File -path $dir1  -Recurse #`
$data = @{}

foreach($file in $d1){
    $prod = "$dir1$file"
    $bak = "$dir2$file"
    
    $info = @{}
    
    $info.Add('filename',$file)
    $info.Add('prod_path',$prod)
    $info.Add('qa_path',$bak)
    
    $ver_sync = @{}

    #get versions of files and compaire
    $ver_sync = Get-Compare_File_Version -prod $prod -bak $bak
    
    if ($get_diff -eq 'Y'){
        if ($ver_sync.prod_ver -eq 'n/a'){
            $diff = Get-Compare_File -prod $prod -bak $bak
            $info.Add('diff_sync',$diff)
        }
    }

    $info.Add('ver_sync',$ver_sync.ver_sync)
    $info.Add('prod_ver',$ver_sync.prod_ver)
    $info.Add('qa_ver',$ver_sync.qa_ver)
    #build array of arrays
    $data.Add($prod,$info)
}



function out-of-sync-table{
    Add-Content 'report.html' '<div class="container">'
    Add-Content 'report.html' '<h2>Version Mismatch</h2>'
    Add-Content 'report.html' '<p>Files where the Versions are Different</p>' 
    Add-Content 'report.html' '<table class="table table-striped">'
    Add-Content 'report.html' '<thead>'
    Add-Content 'report.html' '     <tr>'
    Add-Content 'report.html' '          <TH>Filename</TH>'
    Add-Content 'report.html' '          <TH>Prod Version</TH>'
    Add-Content 'report.html' '          <TH>QA Version</TH>'
    Add-Content 'report.html' '     </tr>'
    Add-Content 'report.html' '</thead>'
    Add-Content 'report.html' '<tbody>'
    foreach($entry in $data.keys){
        #write-host $entry
        foreach($end_data in $data.$entry){ 
            if ($end_data.ver_sync -eq 'N'){
                Add-Content 'report.html' "     <TR>"
                Add-Content 'report.html' "          <TD>", $end_data.filename ,"</TD>" -NoNewline
                Add-Content 'report.html' "          <TD>", $end_data.prod_ver ,"</TD>" -NoNewline
                Add-Content 'report.html' "          <TD>", $end_data.qa_ver ,"</TD>" -NoNewline
                Add-Content 'report.html' "     </TR>"
            }elseif($end_data.diff_sync -eq 'N'){
                Add-Content 'report.html' "     <TR>"
                Add-Content 'report.html' "          <TD>", $end_data.filename ,"</TD>" -NoNewline
                Add-Content 'report.html' "          <TD colspan = '2'>Checksum missmatch </TD>" -NoNewline
                #Add-Content 'report.html' "          <TD>", $end_data.qa_ver ,"</TD>" -NoNewline
                Add-Content 'report.html' "     </TR>"
            }
        }
    }
    Add-Content 'report.html' '</tbody>'
    Add-Content 'report.html' "</TABLE>"
    
}

function all-files-table{
    Add-Content 'report.html' '<div class="container">'
    Add-Content 'report.html' '<h2>All Files</h2>'
    Add-Content 'report.html' '<p>All files scanned</p>' 
    Add-Content 'report.html' '<table class="table table-striped">'
    Add-Content 'report.html' '<thead>'
    Add-Content 'report.html' '     <tr>'
    Add-Content 'report.html' '          <TH>Filename</TH>'
    Add-Content 'report.html' '          <TH>Prod Version</TH>'
    Add-Content 'report.html' '          <TH>QA Version</TH>'
    Add-Content 'report.html' '     </tr>'
    Add-Content 'report.html' '</thead>'
    Add-Content 'report.html' '<tbody>'
    foreach($entry in $data.keys){
        #write-host $entry
        foreach($end_data in $data.$entry){
            if ($end_data.ver_sync -eq 'N'){
                Add-Content 'report.html' '<TR class="danger">'
            }elseif($end_data.diff_sync -eq 'N'){
                Add-Content 'report.html' '     <TR class="danger">'
                Add-Content 'report.html' "          <TD>", $end_data.filename ,"</TD>" -NoNewline
                Add-Content 'report.html' "          <TD colspan = '2'>Checksum missmatch </TD>" -NoNewline
                #Add-Content 'report.html' "          <TD>", $end_data.qa_ver ,"</TD>" -NoNewline
                Add-Content 'report.html' "     </TR>"
            }else{
                Add-Content 'report.html' "<TR>"
            }
            Add-Content 'report.html' "<TD>", $end_data.filename ,"</TD>" -NoNewline
            Add-Content 'report.html' "<TD>", $end_data.prod_ver ,"</TD>" -NoNewline
            Add-Content 'report.html' "<TD>", $end_data.qa_ver ,"</TD>" -NoNewline
            #$end_data.prod_path $end_data.qa_path $end_data.ver_sync $end_data.prod_ver $end_data.qa_ver $end_data.diff
            Add-Content 'report.html' "</TR>"
        }
    }
    Add-Content 'report.html' '</tbody>'
    Add-Content 'report.html' "</TABLE>"
}



#CREATE HTML HERE
if (Test-Path report.html){Remove-Item report.html}


#create HTML
Add-Content 'report.html' '<!DOCTYPE html>
<html lang="en">
<head>
  <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>'





Add-Content 'report.html' "<CENTER>Report of file comparison of <BR><a href='file://$dir1'>$dir1</a> <BR> and <BR><a href='file://$dir2'>$dir2</a></CENTER>"
out-of-sync-table
all-files-table



#open the report
Invoke-Item report.html