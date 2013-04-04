node default {
 package {"unzip": ensure => "installed"}
 
 import "configuration" 

 file { "/usr/bin/java":
    ensure => "link",
    target => "${javaHome}/bin/java",
 }
}