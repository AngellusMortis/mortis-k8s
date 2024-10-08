
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.raid.swraid.monitor;
in
{
  options.hardware.raid.swraid.monitor = {
   enable = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        This option enables mdcheck timers that run regular full scrubs of the
        md devices.  These processes can also cause high I/O utilization; the
        configuration option `boot.kernel.sysctl."dev.raid.speed_limit_max"`
        can be used to limit the I/O utilization of the mdcheck processes.
      '';
    };

    checkStart = mkOption {
      type = types.str;
      default = "Sun *-*-1..7 1:00:00";
      description = lib.mdDoc ''
        systemd OnCalendar expression for when to start an mdcheck operation.
        The default is to begin on the first Sunday of every month at 1am.
      '';
    };

    checkDuration = mkOption {
      type = types.str;
      default = "6 hours";
      description = lib.mdDoc ''
        When mdcheck starts to execute, this option controls how long should
        be spent on the scrub operation before stopping.  The default
        configuration is to scrub for 6 hours, then pause.

        The format of this string must be understood by `date --date`.
      '';
    };

    checkContinue = mkOption {
      type = types.str;
      default = "1:05:00";
      description = lib.mdDoc ''
        systemd OnCalendar expression for when to continue an in-progress
        mdcheck operation that was paused after `duration` time passed.  The
        default is to start at 1:05am every day.  If there is no in-progress
        operation then nothing will be started.
      '';
    };
  };

  config = mkIf cfg.enable {

    nixpkgs.overlays = [
      (self: super: {
        # FIXME: this repackaging adds the mdcheck script and removes the builtin mdcheck_* units;
        # should be upstreamed to nixpkgs:
        # https://github.com/NixOS/nixpkgs/compare/master...mfenniak:nixpkgs:mdcheck?expand=1
        mdadm = super.mdadm.overrideAttrs (finalAttrs: previousAttrs: {
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postInstall = ''
            install -D -m 755 misc/mdcheck ''${out}/bin/mdcheck
            wrapProgram $out/bin/mdcheck \
              --prefix PATH : ''${out}/bin:${lib.makeBinPath [ pkgs.util-linux ]}

            # mdadm's mdmonitor, mdcheck_start & mdcheck_continue units don't have nix
            # paths to the mdcheck script in them as mdadm's Makefile doesn't handle
            # mdcheck path substitutions at all.  Rather than nixifying them though,
            # it makes more sense to remove them and allow same-named units to be
            # configured by a NixOS module, where their configuration options can be
            # properly exposed.  So those modules are removed to avoid naming
            # conflicts.
            rm ''${out}/lib/systemd/system/mdcheck_* ''${out}/lib/systemd/system/mdmonitor*
          '';
        });
      })
    ];

    systemd.services.mdcheck_start = {
      description = "MD array scrubbing";
      wants = [ "mdcheck_continue.timer" ];
      environment.MDADM_CHECK_DURATION = cfg.checkDuration;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.mdadm}/bin/mdcheck --duration \${MDADM_CHECK_DURATION}";
      };
    };

    systemd.timers.mdcheck_start = {
      description = "MD array scrubbing";
      wantedBy = [ "timers.target" ];
      partOf = [ "mdcheck_start.service" ];
      # upstream mdadm has an `Also` to ensure that mdcheck_continue is
      # installed when this unit is installed; not necessary here because
      # they're tied together through nix config.
      timerConfig = {
        OnCalendar = cfg.checkStart;
        Unit = "mdcheck_start.service";
      };
    };

    systemd.services.mdcheck_continue = {
      description = "MD array scrubbing - continuation";
      wants = [ "mdcheck_continue.timer" ];
      environment.MDADM_CHECK_DURATION = cfg.checkDuration;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.mdadm}/bin/mdcheck --continue --duration \${MDADM_CHECK_DURATION}";
      };
    };

    systemd.timers.mdcheck_continue = {
      description = "MD array scrubbing - continuation";
      unitConfig.ConditionPathExistsGlob = "/var/lib/mdcheck/MD_UUID_*";
      wantedBy = [ "timers.target" ];
      partOf = [ "mdcheck_continue.service" ];
      timerConfig = {
        OnCalendar = cfg.checkContinue;
        Unit = "mdcheck_continue.service";
      };
    };
  };
}
