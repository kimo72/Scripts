function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

function runWUSA ($arguments)
{
                   $psi = New-object System.Diagnostics.ProcessStartInfo 
                   $psi.CreateNoWindow = $false 
                   $psi.UseShellExecute = $true 
                   $psi.RedirectStandardOutput = $false 
                   $psi.RedirectStandardError = $false 
                   $psi.FileName = "wusa.exe"
                   $psi.Arguments = "$arguments"
                   $process = New-Object System.Diagnostics.Process 
                   $process.StartInfo = $psi 
                   [void]$process.Start()
                   #$output = $process.StandardOutput.ReadToEnd()
                   $process.WaitForExit()               
                   return $process.ExitCode


}
$path = Get-ScriptDirectory

$updates = Get-ChildItem |where {$_.name -notmatch ".ps1"}

"kimo update" | Out-File -FilePath  $("\\Coboap31\logupdates\" + $env:COMPUTERNAME +".log") -Append
foreach ($update in $updates)
{
$LASTEXITCODE = $null

   if ($update.name -match ".exe")
   {
     
          cmd /C $update.Name
      if ($LastExitCode -ne 0)
        {
            "fallo la instalacion del exe" + $update.Name| Out-File -FilePath  $("\\Coboap31\logupdates\" + $env:COMPUTERNAME +".log") -Append
        }
        else
        {
            "installo correctamente el .exe" | Out-File -FilePath  $("\\Coboap31\logupdates\" + $env:COMPUTERNAME +".log") -Append
        }
   
   
   } 
   else
   {

         $LastExitCode = runWUSA -arguments $($path +"\" + $update.Name +" /quiet /norestart") 
            switch ($LastExitCode)
   {
       '0' { "Instalacion correcta " + $update.Name +"  " + $LastExitCode | Out-File -FilePath  $("\\Coboap31\logupdates\" + $env:COMPUTERNAME +".log") -Append}
       '3010' {  "Pendiente reinicio  " + $update.Name + "codigo " + $LastExitCode | Out-File -FilePath  $("\\Coboap31\logupdates\" + $env:COMPUTERNAME +".log") -Append}
       Default {  "Fallo la instalacion de  " + $update.Name + "con el codigo " + $LastExitCode | Out-File -FilePath  $("\\Coboap31\logupdates\" + $env:COMPUTERNAME +".log") -Append}
   }
       

   }
}
