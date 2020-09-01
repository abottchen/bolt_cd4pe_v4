# vagrant_bolt_cd4pe_v4

vagrant_bolt_cd4pe_v4::install - This plan installs the latest version of Replicated and installs it.  It then deploys CD4PE using the license provided

USAGE:
```
bolt plan run vagrant_bolt_cd4pe_v4::install targets=<value> license=<value> [root_user=<value>] [root_password=<value>] [console_password=<value>]
```

PARAMETERS:
```
- targets: TargetSpec
    The list of targets on which to install
- license: String[1]
    The path to your Replicated license file on your local system
- root_user: Optional[String[1]]
    Default: 'root@puppet.com'
    The root user email address for CD4PE
- root_password: Optional[String[1]]
    Default: 'test'
    The root user password for CD4PE
- console_password: Optional[String[1]]
    Default: 'puppetlabs'
    The password for the platform admin console
```

Examples:

```
# bolt plan run vagrant_bolt_cd4pe_v4::install -m modules:.. --user centos --run-as root --targets replicated-cdpe-node1.puppetdebug.vlan license=~/Desktop/mylicense.yaml
```

Notes:

After the plan runs, you can log into the platform admin console at `https://hostname:8800`.  You can log into the resulting CD4PE instance at `https://hostname`.

Known issues:

- If you set a custom hostname in your debug kit configuration, it can cause the plan to fail.  For now, just let the VMs use their default domains.

