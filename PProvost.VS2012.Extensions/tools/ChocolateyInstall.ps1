$packageName = 'PProvost.VS2012.Extensions'

function Get-Batchfile ($file) {
	$cmd = "`"$file`" & set"
		cmd /c $cmd | Foreach-Object {
			$p, $v = $_.split('=')
			Set-Item -path env:$p -value $v
		}
}

function VsVars32() {
	$BatchFile = join-path $env:VS110COMNTOOLS "vsvars32.bat"
	Get-Batchfile `"$BatchFile`"
}

function get-webfile($url, $filename) {
	$path = join-path $env:temp $filename
	if( test-path $path ) { rm -force $path }
	(new-object net.webclient).DownloadFile($url, $path)
	return new-object io.fileinfo $path
}

function install-vsix($url, $name) {
  echo "Installing $name"
  $extension = (get-webfile $url $name).FullName
  $result = Start-Process -FilePath "VSIXInstaller.exe" -ArgumentList "/q $extension" -Wait -PassThru;
}

try {
	vsvars32

	install-vsix http://visualstudiogallery.msdn.microsoft.com/e5f41ad9-4edc-4912-bca3-91147db95b99/file/7088/6/PowerCommands.vsix PowerCommands.vsix
	install-vsix http://visualstudiogallery.msdn.microsoft.com/59ca71b3-a4a3-46ca-8fe1-0e90e3f79329/file/6390/26/VsVim.vsix VsVim.vsix
	install-vsix http://visualstudiogallery.msdn.microsoft.com/07d54d12-7133-4e15-becb-6f451ea3bea6/file/79465/11/WebEssentials2012.vsix WebEssentials.vsix
	install-vsix http://visualstudiogallery.msdn.microsoft.com/366ad100-0003-4c9a-81a8-337d4e7ace05/file/82992/3/ColorThemeEditor.vsix ColorThemeEditor.vsix
	install-vsix http://visualstudiogallery.msdn.microsoft.com/a83505c6-77b3-44a6-b53b-73d77cba84c8/file/74740/18/SquaredInfinity.VSCommands.VS11.vsix VsCommands.vsix
	install-vsix http://visualstudiogallery.msdn.microsoft.com/6e54271c-2c4e-4911-a1b4-a65a588ae138/file/85910/4/TfsGoOffline.vsix Tfs-GoOffline
	install-vsix http://visualstudiogallery.msdn.microsoft.com/B08B0375-139E-41D7-AF9B-FAEE50F68392/file/5131/7/SnippetDesigner.vsix SnippetDesigner.vsix

	install-vsix http://visualstudiogallery.msdn.microsoft.com/6ab922d0-21c0-4f06-ab5f-4ecd1fe7175d/file/66177/10/NUnitTestAdapter.vsix NUnitTestAdapter.vsix
	install-vsix http://visualstudiogallery.msdn.microsoft.com/463c5987-f82b-46c8-a97e-b1cde42b9099/file/66837/8/xunit.runner.visualstudio.vsix xunit.runner.visualstudio.vsix
	install-vsix http://visualstudiogallery.msdn.microsoft.com/f8741f04-bae4-4900-81c7-7c9bfb9ed1fe/file/66979/14/Chutzpah.VS2012.vsix Chutzpah.VS2012.vsix

	Write-ChocolateySuccess $packageName
} catch {
	Write-ChocolateyFailure $packageName "$($_.Exception.Message)"
	throw
}
