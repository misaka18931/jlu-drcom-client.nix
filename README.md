# jlu-drcom-client.nix

Net Authentication Client for JiLin University as a NixOS module.

ported from `github:AndrewLawrence80/jlu-drcom-client`.

## Usage

### for Flakes users

```nix
{
    inputs = {
        drcom.url = "github:misaka18931/jlu-drcom-client.nix";
        drcom.inputs.nixpkgs.follows = "nixpkgs";
        ...
    };
    outputs = { drcom, ... }:
    {
        nixosConfigurations."yourHostname" = nixpkgs.lib.nixosSystem {
            modules = [
                drcom.nixosModules.default
                {
                    services.jlu-netauth = {
                        enable = true;
                        configFile = "/path/to/config";
                        healthcheckInterval = 10; # check connectivity every 10 seconds
                    };
                }
            ];
            ...
        };
    }
}
```

### for non-Flake users

package.nix contains the package for the binary.

module.nix is a NixOS module that provides `services.jlu-netauth`.

### Configuration

Credentials are passed to the program by systemd's `EnvironmentFile`.

```
# path/to/config
JLU_USERNAME=your username at mails.jlu.edu.cn
JLU_PASSWD=your passwd for mails.jlu.edu.cn
JLU_IPADDR=your ip address assigned (found in ip.jlu.edu.cn)
JLU_HWADDR=your MAC address registered in ip.jlu.edu.cn
```
**DO NOT** put your plaintext credentials directly into `services.jlu-drcom-client.configFile`, as they will end up in the world readable `/nix/store`.
Instead, use a secret management scheme like `sops-nix`.

### Explaination

The NixOS module creates 3 systemd services.
- `jlu-netauth.service`: run the authentication service listening @ `0.0.0.0:61440`.
- `jlu-netauth-monitor.service`: check authentication status every 10 seconds by curling 10.100.61.3(auth.jlu.edu.cn). If the session ever expires, restart jlu-netauth.service. The interval is specified in `services.jlu-netauth.healthcheckInterval`.
- `jlu-netauth-autorestart.service`: logout before system suspension, log back in upon resume.

Thanks @AndrewLawrence80 for amazing [repository](https://github.com/AndrewLawrence80/jlu-drcom-client).
