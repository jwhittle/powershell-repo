#get list of services



function WaitUntilServices($searchString, $status){
    # Get all services where DisplayName matches $searchString and loop through each of them.
    
    foreach($service in (Get-Service -DisplayName $searchString))
    {
        # Wait for the service to reach the $status or a maximum of 30 seconds
        try {$service.WaitForStatus($status, '00:00:10')}catch{write-host $error[0].Exception}

        write-host $service.DisplayName $service.Status
        
    }
}

function Start-Stop_Services($searchString, $status){ #Status: Start, Stop
    write-host $searchString
    write-host $status
    if ($status -eq "Start"){
        Get-Service | Where {$_.name -like 'spooler*'} | Start-Service
        WaitUntilServices "Print spooler*" "Running"
    }elseif ($status -eq 'Stop'){
        Get-Service | Where {$_.name -like 'spooler*'} | Stop-Service
        WaitUntilServices "Print spooler*" "stopped"
    }else{
        write-host "wrong syntax"
    }
    #else complain and give example
}


Start-Stop_Services "fdsfdsf","Start"

