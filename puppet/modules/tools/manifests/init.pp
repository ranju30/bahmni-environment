class tools {
	package {"unzip": ensure => "installed"}
	package {"zip": ensure => "installed"}
	package {"wget": ensure => "installed"}
}