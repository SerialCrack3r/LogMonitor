Function MetricProcessor ([LogMonitor.FileChange] $change)
{
    If (!$change)
    {
        Throw "No change specified."
    }
        
    $metrics = @()
        
    if ($change.GetType().FullName -eq "LogMonitor.Processors.W3CChange")
    {  
		$http_1xx = 0
		$http_2xx = 0
		$http_3xx = 0
		$http_4xx = 0
		$http_5xx = 0
        
		$statusIndex = [array]::indexof($change.FieldNames,[LogMonitor.Processors.W3CFields]::ScStatus)
        
		foreach ($values in $change.Values)
		{
			if ($statusIndex -ge 0 -And $values.length -gt $statusIndex)
			{
				$status = [int]$values[$statusIndex]
            
				if ($status -lt 200) { $http_1xx += 1 }
				ElseIf ($status -lt 300) { $http_2xx += 1 }
				ElseIf ($status -lt 400) { $http_3xx += 1 }
				ElseIf ($status -lt 500) { $http_4xx += 1 }
				Else { $http_5xx += 1 }
			}
		}
        
		$metrics += [LogMonitor.Metric]::Create('http_1xx', [float]$http_1xx, [LogMonitor.MetricType]::Counter)
		$metrics += [LogMonitor.Metric]::Create('http_2xx', [float]$http_2xx, [LogMonitor.MetricType]::Counter)
		$metrics += [LogMonitor.Metric]::Create('http_3xx', [float]$http_3xx, [LogMonitor.MetricType]::Counter)
		$metrics += [LogMonitor.Metric]::Create('http_4xx', [float]$http_4xx, [LogMonitor.MetricType]::Counter)
		$metrics += [LogMonitor.Metric]::Create('http_5xx', [float]$http_5xx, [LogMonitor.MetricType]::Counter)
    }
        
    return $metrics
}