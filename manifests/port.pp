# define: selinux::port
#
# Change SELinux port context.
#
# Example: allow ssh on a different port
#   selinux::port { 'tcp 2222':
#     protocol =>  'tcp',
#     port =>  '2222',
#     seltype =>  'ssh_port_t',
#   }
#
define selinux::port (
  $protocol = 'tcp',
  $port,
  $seltype,
  $recurse = false,
) {

  if $::selinux {

    # Run semanage to persistently set the SELinux Type.
    exec { "semanage_port_${seltype}_${protocol}_${port}":
      command => "semanage port -a -t ${seltype} -p ${protocol} ${port}",
      path    => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
      unless  => "semanage port -l -C -n | grep ^${seltype}.*${protocol}.*${port}$",
    }

  }

}
