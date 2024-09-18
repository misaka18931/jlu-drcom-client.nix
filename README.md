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
                    enable = true;
                    configFile = "/path/to/config";
                }
            ];
            ...
        };
    }
}
```

### for non-Flake users

not tested yet.

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

Thanks @AndrewLawrence80 for amazing [repository](https://github.com/AndrewLawrence80/jlu-drcom-client).
