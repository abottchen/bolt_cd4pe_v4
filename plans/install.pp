# This plan installs the latest version of Replicated and installs it.  It then deploys CD4PE using the license provided
# @param targets The list of targets on which to install
# @param license The path to your Replicated license file on your local system
# @param root_user The root user email address for CD4PE
# @param root_password The root user password for CD4PE
# @param console_password The password for the platform admin console
plan bolt_cd4pe_v4::install (
  TargetSpec $targets,
  String[1] $license,
  Optional[String[1]] $root_user = 'root@puppet.com',
  Optional[String[1]] $root_password = 'test',
  Optional[String[1]] $console_password = 'puppetlabs',
) {


  $install_dir = "/root/cd4pe_install"

  # Get the hostname of the target system
  $targets.apply_prep
  without_default_logging() || { run_plan(facts, targets => $targets) }
  $target_facts = get_target($targets).facts()
  $target_fqdn = $target_facts['fqdn']

  # Install Replicated and post install
  run_command("curl -sSL https://pup.pt/install-cd4pe | sudo bash", $targets)
  run_command("cp /etc/kubernetes/admin.conf ~/.kube/config ; chown -R 0 ~/.kube ; echo unset KUBECONFIG >> ~/.profile", $targets)

  run_command("mkdir ${install_dir}", $targets)

  # Upload the license file
  upload_file($license, "${install_dir}/license.json", $targets)

  # Create config.yaml
  apply($targets) {
    file{"${install_dir}/config.yaml":
      ensure => file,
      content => epp('bolt_cd4pe_v4/config.yaml.epp', 'root_user' => $root_user, 'root_password' => $root_password, 'target_fqdn' => $target_fqdn),
    }
  }

  # Deploy CD4PE
  run_command("/usr/local/bin/kubectl-kots install cd4pe/stable --namespace default --shared-password puppetlabs --port-forward=false --license-file ${install_dir}/license.json --config-values ${install_dir}/config.yaml", $targets)

  # Set the Platform Admin Console password  
  run_command("echo '${console_password}' | /usr/local/bin/kubectl-kots reset-password default", $targets)
}
