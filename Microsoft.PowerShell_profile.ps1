#PS profile
# Fhelp             Quickly gets the full help for a cmdlet 
# Ehelp             Quickly gets the examples help for a cmdlet 
# Reset-Eventlog    Sets all event logging levels back to default 
# Set-Smp           Grant a user "Send as" and Full Mailbox Access permission on a target mailbox 
# npp               Launches Notepad2
# sh                starts RemoteSshell session
# ssh               starts Secure RemoteShell Session

Get-PSSnapin -registered | Add-PSSnapin -PassThru
#Get-Module -ListAvailable | import-module

$exscripts = 'c:\program files\Microsoft\Exchange Server\v14\scripts'
Set-Location c:\scripts
 
# Formating Variables 
# Allows a Central place for defining color variables 
 
[string]$success = 'Green'        # Color for "Positive" messages 
[string]$info     = 'White'        # Color for informational messages 
[string]$warning = 'Yellow'        # Color for warning messages 
[string]$fail     = 'Red'        # Color for error messages 

 
# Set Alias Names 

 
new-Alias set-smp Set-SharedMailboxPermisions 
new-Alias remove-smp remove-SharedMailboxPermisions 
set-alias npp 'C:\Program Files (x86)\Flos\Notepad2\notepad2.exe'
set-alias ssh New-PSSecureRemoteSession
set-alias sh New-PSRemoteSession

# Function to create Secure Remote Shell Session
# Single expected input of server name
# Example: "ssh wndmail01"
# ==============================================================================
Function New-PSSecureRemoteSession  {
    param ($sshServerName, $Cred)
    $Session = New-PSSession $sshServerName -UseSSL -Credential $Cred
    Enter-PSSession -Session $Session
}

# Function to create Remote Shell Session
# Single expected input of server name
# Example: "ssh wndmail01"
# ==============================================================================
Function New-PSRemoteSession  {
    param ($shServerName, $Cred)
    $Session = New-PSSession $shServerName -Credential $Cred
    Enter-PSSession -Session $Session
}


# Function to show the full help for a given cmdlet 
# Single expected input of the cmdlet name 
# Example: "Fhelp mount-database" 
# ================================================================================ 
 
Function fhelp { 
 
    param ([string]$cmdlet) 
 
help $cmdlet -full 
 
} 
 
 
# Function to just show the examples for a given cmdlet 
# Single expected input of the cmdlet name 
# Example:  "Ehelp mount-database" 
# ================================================================================ 
 
Function ehelp { 
 
    param ([string]$cmdlet) 
 
    help $cmdlet -example 
 
} 
 
 
 
 
# Resets the event log levels on a server to the default values 
# Single expected input of the servers name (Reset-eventloglevel myserver) 
# Defaults to the local machine name 
# Example:  "Reset-Eventloglevel MyServer" 
# ================================================================================ 
 
Function Reset-EventLogLevel
{ 
    param ([string]$server = (hostname)) 

    get-eventloglevel -server $server | where {$_.level -ne 'Lowest'} | set-eventloglevel -level lowest 
 
    set-eventloglevel -id "$server\MSExchange ADAccess\Validation" -level Low 
    set-eventloglevel -id "$server\MSExchange ADAccess\Topology" -level Low 
} 
 
 
# Sets the permissions needed for one user to access another users mailbox and "Send as" them 
# Example:  "set-sharedmailboxpermisions UserA ServiceAcct" 
# ================================================================================ 
 
Function Set-SharedMailboxPermisions
{ 
    Param ([string]$target,[string]$granted) 
 
    Add-ADPermission $target -User $granted -Extendedrights 'Send As' 
    Add-MailboxPermission $target -AccessRights FullAccess -user $granted  
 
} 


# Removes the permissions needed for one user to access another users mailbox and "Send as" them 
# Example:  "set-sharedmailboxpermisions UserA ServiceAcct" 
# ================================================================================ 
 
Function Remove-SharedMailboxPermisions
{ 
    Param ([string]$target,[string]$granted) 
 
    Remove-ADPermission $target -User $granted -Extendedrights 'Send As' 
    Remove-MailboxPermission $target -AccessRights FullAccess -user $granted  
 
} 



function Get-UNCPath
{
  $currentDirectory = Get-Location
  $currentDrive = Split-Path -qualifier $currentDirectory.Path
  $logicalDisk = Gwmi Win32_LogicalDisk -filter "DriveType = 4 AND DeviceID = '$currentDrive'"
  Write-Output $currentDirectory.Path.Replace($currentDrive, $logicalDisk.ProviderName)
}

function OpenProfile
{
  npp $profile
}


function prompt
{
	$promptText = 'PS ' + $(get-location) + '>';
#	$promptText = "PS>";
  $wi = [System.Security.Principal.WindowsIdentity]::GetCurrent()	
	$wp = new-object 'System.Security.Principal.WindowsPrincipal' $wi
	if ( $wp.IsInRole('Administrators') -eq 1 )
		{		$color = 'Green'
				#$title = "**ADMIN** on " + (hostname);
        $title = (get-content env:\userdomain) + '\' + (get-content env:\username) + ' on ' + (hostname);
		}	
		else
		{		$color = 'Red'
 			$title = hostname;
  	}	write-host $promptText -NoNewLine -ForegroundColor $color
			$host.UI.RawUI.WindowTitle = $title;
			return ' '
}


function osr { shutdown -r -t 5 }

function osh { shutdown -h -t 5 }

function rmd ([string] $glob) { remove-item -recurse -force $glob }

function whoami { (get-content env:\userdomain) + '\' + (get-content env:\username); }

function strip-extension ([string] $filename)
{
     [system.io.path]::getfilenamewithoutextension($filename)
} 

