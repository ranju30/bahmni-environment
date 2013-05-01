class python {
	 package { "epel-release" :
     provider => rpm,
     ensure => installed,
     source => "http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"
 	}

	package { "pgdg-centos92-9.2-6.noarch" :
     provider => rpm,
     ensure => installed,
     source => "http://yum.pgrpms.org/9.2/redhat/rhel-6-i386/pgdg-centos92-9.2-6.noarch.rpm",
     require => Package["epel-release"]
 	}

  package { "python-psycopg2" : ensure => installed, require => Package["pgdg-centos92-9.2-6.noarch"] }
  package { "python-lxml" : ensure => installed, require => Package["python-psycopg2"] }
  package { "PyXML" : ensure => installed, require => Package["python-lxml"] }
  package { "python-setuptools" : ensure => installed, require => Package["PyXML"] }
  package { "libxslt-python" : ensure => installed, require => Package["libxslt-python"] }
  package { "pytz" : ensure => installed, require => Package["libxslt-python"] }

  package { "python-matplotlib" : ensure => installed, require => Package["pytz"] }
  package { "python-babel" : ensure => installed, require => Package["python-matplotlib"] }
  package { "python-mako" : ensure => installed, require => Package["python-babel"] }
  package { "python-dateutil" : ensure => installed, require => Package["python-mako"] }
  
  package { "pychart" : ensure => installed, require => Package["python-dateutil"] }
  package { "pydot" : ensure => installed, require => Package["pychart"] }
  package { "python-reportlab" : ensure => installed, require => Package["pydot"] }
  package { "python-devel" : ensure => installed, require => Package["python-reportlab"] }
  package { "python-imaging" : ensure => installed, require => Package["python-devel"] }
  package { "python-vobject" : ensure => installed, require => Package["python-imaging"] }

  package { "hippo-canvas-python" : ensure => installed, require => Package["python-vobject"] }
  package { "mx" : ensure => installed, require => Package["hippo-canvas-python"] }
  package { "python-gdata" : ensure => installed, require => Package["mx"] }
  package { "python-ldap" : ensure => installed, require => Package["python-gdata"] }
  package { "python-openid" : ensure => installed, require => Package["python-ldap"] }

  package { "python-werkzeug" : ensure => installed, require => Package["python-openid"] }
  package { "python-vatnumber" : ensure => installed, require => Package["python-werkzeug"] }
  package { "pygtk2" : ensure => installed, require => Package["python-vatnumber"] }
  package { "glade3" : ensure => installed, require => Package["pygtk2"] }

  package { "python" : ensure => installed, require => Package["glade3"] }
  package { "python-psutil" : ensure => installed, require => Package["python"] }
  package { "python-docutils" : ensure => installed, require => Package["python-psutil"] }
  package { "make" : ensure => installed, require => Package["python-docutils"] }
  
  package { "automake" : ensure => installed, require => Package["make"] }
  package { "gcc" : ensure => installed, require => Package["automake"] }
  package { "gcc-c++" : ensure => installed, require => Package["gcc"] }
  package { "kernel-devel" : ensure => installed, require => Package["gcc-c++"] }
  package { "byacc" : ensure => installed, require => Package["kernel-devel"] }
  package { "flashplugin-nonfree" : ensure => installed, require => Package["byacc"] }
  package { "poppler-utils" : ensure => installed, require => Package["flashplugin-nonfree"] }
  package { "pywebdav" : ensure => installed, require => Package["poppler-utils"] }

  exec { "pyparsing" :
  	command => "easy_install http://cheeseshop.python.org/packages/source/p/pyparsing/pyparsing-1.5.5.tar.gz",
  	path => "${os_path}",
  	require => Package["pywebdav"]
  }
}