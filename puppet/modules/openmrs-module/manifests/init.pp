class openmrs-module ( $omod_file_name) {
	exec { "name":
		command => "/bin/echo",
		#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
		#refreshonly => true,
	}

	exec { "upload-module":
		command => "${basedir}/openmrs-modules/scripts/upload-modules.sh",
		#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
		#refreshonly => true,
	}
}
		# <exec executable="${basedir}/openmrs-modules/scripts/upload-modules.sh" failonerror="true">
		#   <arg value="${openmrs.password}"/>
		#   <arg value="${openmrs.rest.module}"/>
		#   <arg value="http://modules.openmrs.org/modules/download/webservices.rest19ext/webservices.rest19ext-1.0.29298.omod"/>
		#   <arg value="http://modules.openmrs.org/modules/download/idgen/idgen-2.4.1.omod"/>
		#   <arg value="${bhamni.core.module}"/>
		# </exec>
  #   </target>
