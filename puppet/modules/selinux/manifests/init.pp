class selinux {

    if ($selinux)
    {
        selboolean { 'httpd_read_user_content':
            name       => 'httpd_read_user_content',
            persistent => true,
            value      => on
        }

        selboolean { 'httpd_can_network_relay':
            name       => 'httpd_can_network_relay',
            persistent => true,
            value      => on
        }
    }
}