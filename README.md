# jlu-drcom-client.nix

Net Authentication Client for JiLin University as a NixOS module.

ported from `github:AndrewLawrence80/jlu-drcom-client`

## Usage

Credentials are passed to the program by systemd's `EnvironmentFile`.

### configuration file format
```
# path/to/config
JLU_USERNAME=your username at mails.jlu.edu.cn
JLU_PASSWD=your passwd for mails.jlu.edu.cn
JLU_IPADDR=your ip address assigned (found in ip.jlu.edu.cn)
JLU_HWADDR=your MAC address registered in ip.jlu.edu.cn
```
**DO NOT** put your plaintext credentials directly into `services.jlu-drcom-client.configFile`, as they will end up in the world readable `/nix/store`.
Instead, use a secret management scheme like `sops-nix`.
