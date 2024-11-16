{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.jlu-netauth;
in
{
  options.services.jlu-netauth = {
    enable = lib.mkEnableOption "NetAuthentication service for JiLin University";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix {
        hostname = "${config.networking.hostName}";
        debug = false;
      };
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "login credential file to use.";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services = {
      "jlu-netauth" = {
        description = "NetAuthentication service for JiLin University";
        requires = [ "network-online.target" ];
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = lib.getExe cfg.package;

          DynamicUser = true;
          StateDirectory = "jlu_netauth";
          EnvironmentFile = "${cfg.configFile}";

          ### Hardening
          AmbientCapabilities = "";
          CapabilityBoundingSet = "";
          DeviceAllow = "";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RestrictNamespaces = true;
          RestrictAddressFamilies = "AF_INET AF_INET6";
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service bpf";
          UMask = "0077";
        };
      };
      "jlu-netauth-monitor" = let 
        healthCheckScript = pkgs.writeScript "jlu-netauth-monitor" ''
        #!/bin/sh
        while true; do
          sleep 10
          ${pkgs.curl}/bin/curl -s "10.100.61.3" | grep -q 'login.jlu.edu.cn' && ${pkgs.systemd}/bin/systemctl restart jlu-netauth
        done
        '';
      in {
        description = "health check for jlu-netauth service.";
        wantedBy = [ "jlu-netauth.service" ];

        serviceConfig = {
          ExecStart = "${healthCheckScript}";
        };
      };
      "jlu-netauth-autorestart" = {
        description = "Auto restart jlu-netauth service on resume.";
        before = [ "sleep.target" ];
        wantedBy = [ "sleep.target" ];
        unitConfig = {
          StopWhenUnneeded = true;
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = "${pkgs.systemd}/bin/systemctl stop jlu-netauth";
          ExecStop = "${pkgs.systemd}/bin/systemctl start jlu-netauth";
        };
      };
    };
  };
}
