class tools {
	#require yum-repo

	package {"unzip" : ensure => "installed"}
	package {"zip" : ensure => "installed"}
	package {"wget" : ensure => "installed"}
}