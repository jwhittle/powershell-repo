#get list of services
#this is the J&J Branch

#$sqlConn = New-Object System.Data.SqlClient.SqlConnection
#$sqlConn.ConnectionString = “Server=localhost\sql12;Integrated Security=true;Initial Catalog=master”
#$sqlConn.Open()
$config = @{
    'logfile' = 'C:/temp/log.txt'
    }


$logfile = 'C:/temp/log.txt'
$lightController = 'ExactaLightController'

#created the array of zones and parameter
$zones = @{
    'Light controler zone 01'='01';
    'Light controler zone 02'='02';
    'Light controler zone 03'='03';
    'Light controler zone 04'='04';
    'Light controler zone 05'='05';
    'Light controler zone 06'='06';
    }

$linkboxes = @{
    'LB1' = '127.0.0.1';
    'LB2' = '127.0.0.2';
    'LB3' = '127.0.0.3';
    'LB4' = '127.0.0.4';
    'LB5' = '127.0.0.5';
    }

function log($logfile, $data) {
    filter timestamp {"$(Get-Date -Format G): $_"}
    write-output $data | timestamp  -NoNewline
    
}

function WaitUntilServices($searchString, $status){
    # Get all services where DisplayName matches $searchString and loop through each of them.
    log -logfile $logfile -data "Attempting to $status $searchString"
    foreach($service in (Get-Service -DisplayName $searchString))
    {
        # Wait for the service to reach the $status or a maximum of 30 seconds
        try {$service.WaitForStatus($status, '00:00:10')}catch{write-host $error[0].Exception}

        log -logfile $logfile -data $service.DisplayName $service.Status
        
    }
}

function Start-Stop_Services{ #Status: Start, Stop
    param([string]$searchString, [string]$status, [string]$parameter)
    log -logfile $logfile -data "Attempting to $status $searchString"
    if ($status -eq 'Start'){
        #$myservice = Get-Service $searchString
        #$myservice.Start($parameter)
        #WaitUntilServices "$searchString" "Running"
        log -logfile $logfile -data "$searchString Stopped"
    }elseif ($status -eq 'Stop'){
        #$myservice = Get-Service $searchString
        #$myservice.Start($parameter)
        log -logfile $logfile -data "$searchString Started"
    }else{
        write-host "wrong syntax"
    }
    #else complain and give example
}

function Restart-Linbox($ip, $name){
    $info = "Attepting to restart linkbox $linkbox at "+($linkboxes.$linkbox | Out-String) 
       # log -logfile $logfile -data $info
    log -logfile $logfile -data $info -NoNewline
}





Function main{
    Clear-host
    log -logfile $logfile -data "######Stopping Light Controller####"
    Start-Stop_Services -searchString $lightController -status "Stop"
    
    
    log -logfile $logfile -data "######Stopping All Zones####"
    foreach ($zone in $zones.keys){
        #write-host '     Stop Service ', $zone , 'Param ',$zones.$zone
        Start-Stop_Services -searchString $zone -status "Stop"
        
    }
    log -logfile $logfile -data "######Restarting All LinkBoxes####"
    foreach ($linkbox in $linkboxes.keys){
        Restart-Linbox -name $linkbox -ip $linkboxes.$linkbox
        #write-host '     Restart Linkbox' ,$linkbox, 'IP:', $linkboxes.$linkbox
    }

    log -logfile $logfile -data "######Starting Light Controller####"
    Start-Stop_Services -searchString $lightController -status "Start"
    
    
    log -logfile $logfile -data "######Starting All Zones####"
    foreach ($zone in $zones.keys){
        #write-host '     Stop Service ', $zone , 'Param ',$zones.$zone
        Start-Stop_Services -searchString $zone -status "Start"
        
    }

}



main