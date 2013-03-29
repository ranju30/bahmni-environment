class registration::deploy {

	file { "${registrationZipFilePath}": }

	exec { "unzip_file":
        command     => "unzip -o ${registrationZipFilePath} -d ${tomcatWebappDir}/registration",
        provider    => "shell",
        require     => [File["${registrationZipFilePath}"]],
    }
}