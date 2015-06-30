class bahmni_pacs {
	if ($bahmni_pacs_required == "true") {
		require pacs
	} else {
		notice ("Not installing PACS Module. ")
	}
}