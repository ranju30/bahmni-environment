On Nagios server
=================
 * Change the $nagios_machine_type to "server"
 * Ensure correct settings are in $primary_machine_ip, $secondary_machine_ip, $primary_machine_host_name, $primary_machine_host_name, 
   and the Nagios support emails (to/from)
 * Run the puppet module 'nagios' and 'bahmni_nagios'
 * Run the below command to set the password for nagiosadmin (Set password to nagiosadmin)
 	 htpasswd -c /etc/nagios/htpasswd.users nagiosadmin
 * Restart httpd
 * If Nagios is setup properly you should be able to login with nagiosadmin credentials at:
   	 http://<Machine IP>/nagios/

 On Nagios Client
 ================
 * Change the $nagios_machine_type to "client"
 * Ensure correct settings are in $primary_machine_ip, $secondary_machine_ip, $primary_machine_host_name, $primary_machine_host_name, 
   and the Nagios support emails (to/from)
 * Run the puppet module nagios and bahmni_nagios