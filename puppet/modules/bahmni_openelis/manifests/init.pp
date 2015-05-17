class bahmni_openelis inherits bahmni_openelis::config {
	if ("${::config::bahmni_openelis_required}" == "true") {
		require openelis
	} else {
		notice ("Not installing OpenElis. ")
	}
}