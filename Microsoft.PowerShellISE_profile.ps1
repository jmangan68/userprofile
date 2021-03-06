Get-PSSnapin -registered | Add-PSSnapin -PassThru
#Get-Module -ListAvailable | import-module

$exscripts = 'c:\program files\Microsoft\Exchange Server\v14\scripts'
set-location c:\scripts

$QADTools = @'
  function Add-QADTools
  {
  $Quest = Get-PSSnapin Quest.ActiveRoles.ADManagement -ErrorAction silentlycontinue
  if ($Quest)
    {
       Write-Debug "Quest.ActiveRoles.ADManagement Snapin loaded"
    }
  if (!$Quest)
    {
       Write-Debug "Loading Quest.ActiveRoles.ADManagement Snapin"
       Add-PSSnapin Quest.ActiveRoles.ADManagement
       if (!$?) {"Need to install AD Snapin from http://www.quest.com/powershell";exit}
    }
  }
  Add-QADTools
'@

  $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Insert QAD Tools", `
{$psise.CurrentFile.Editor.InsertText($QADTools)},"ALT+F5") | out-Null



$InsertCommentBlock = @'
#################################################
#  Title:
#  Author:
#  Date: 
#  Description:
#
#
#################################################

'@

  $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Insert CommentBlock", `
{$psise.CurrentFile.Editor.InsertText($InsertCommentBlock)},"ALT+C") | out-Null

