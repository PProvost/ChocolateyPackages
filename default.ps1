# Dependencies:
#  - psake - http://github.com/psake/psake/
#  - chocolatey - http://chocolatey.org/

properties {
	$baseDir = (resolve-path ".")
	$outputDir = "$baseDir\Pack\"
	$version = (get-date -f "yyyy.MM.dd")
}

task default -depends Pack

task Clean {
	if (test-path $outputDir) {
		remove-item -recurse $outputDir
	}
}

task Pack -depends Clean {
	mkdir $outputDir

	ls -rec -fil *.nuspec | % {
		$dirName = $_.Directory.Name
		copy-item $dirName $outputDir -recurse -container

		pushd $outputDir
		$specfile = "$outputDir\$dirName\$($_.Name)"

		write-host $specfile -fore Yellow

		$nuspec = [xml] (get-content $specfile)
		$nuspec.package.metadata.version = ([string] $nuspec.package.metadata.version).Replace("{VERSION}", $version)
		$nuspec.Save($specfile)

		exec { cpack "$specfile" }

		remove-item -recurse -force $dirName
		popd
	}
}


