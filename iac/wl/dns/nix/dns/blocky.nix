# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        dig
        blocky
    ];

    networking.firewall.allowedTCPPorts = [ 53 4000 ];
    networking.firewall.allowedUDPPorts = [ 53 ];

    systemd.services.blocky.after = [ "network-online.target" ];
    systemd.services.blocky.wants = [ "network-online.target" ];
    services.blocky = {
        enable = true;
        settings = {
            ports.dns = 53; # Port for incoming DNS Queries.
            ports.http = 4000;
            upstreams.init.strategy = "fast";
            upstreams.groups.default = [
                "https://9.9.9.9/dns-query"
                "https://1.1.1.1/dns-query"
                "https://1.0.0.1/dns-query"
            ];
            # For initially solving DoH/DoT Requests when no system Resolver is available.
            bootstrapDns = {
                upstream = "https://9.9.9.9/dns-query";
                ips = [ "9.9.9.9" "1.1.1.1" ];
            };
            caching = {
                minTime = "5m";
                maxTime = "30m";
                maxItemsCount = 10000;
                prefetching = true;
            };
            #Enable Blocking of certain domains.
            blocking = {
                blockType = "zeroIP";
                allowlists = {
                    ads = [
                        ''
                        collector.newrelic.com
                        adfoc.us
                        insights-collector.newrelic.com
                        ''
                    ];
                };
                denylists = {
                    #Adblocking
                    ads = [
                        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                        "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
                        "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
                    ];
                    #Another filter for blocking adult sites
                    # adult = ["https://blocklistproject.github.io/Lists/porn.txt"];
                    #You can add additional categories
                };
                #Configure what block categories are used
                clientGroupsBlock = {
                    default = [ "ads" ];
                    # kids-ipad = ["ads" "adult"];
                };
            };
            customDNS = {
                customTTL = "1h";
                filterUnmappedTypes = false;
                rewrite = {
                    wl = "wl.mort.is";
                    home = "wl.mort.is";
                    lan = "wl.mort.is";
                };
                mapping = {
                    # upstream UniFi stuff
                    "network-control.wl.mort.is" = "192.168.3.1";
                    "protect-control.wl.mort.is" = "192.168.1.16";

                    # upstream core services
                    "pi-1.wl.mort.is" = "192.168.1.10";
                    "pi-1" = "192.168.1.10";
                    "pi-2.wl.mort.is" = "192.168.1.12";
                    "pi-2" = "192.168.1.12";

                    "home-control.wl.mort.is" = "192.168.2.12";

                    # dc stuff
                    "backup-1-ipmi.dc.mort.is" = "192.168.1.25";
                    "backup-1.dc.mort.is" = "192.168.52.50";
                    "auth.dc.mort.is" = "192.168.3.225";
                    "sync.dc.mort.is" = "192.168.2.225";

                    # k8s servers
                    ## computer cluster / IPMI
                    "cluster-1-ipmi.wl.mort.is" = "192.168.1.81";
                    "cluster-1-ipmi" = "192.168.1.81";
                    "cluster-2-ipmi.wl.mort.is" = "192.168.1.41";
                    "cluster-2-ipmi" = "192.168.1.41";
                    "cluster-3-ipmi.wl.mort.is" = "192.168.1.42";
                    "cluster-3-ipmi" = "192.168.1.42";
                    "cluster-4-ipmi.wl.mort.is" = "192.168.1.43";
                    "cluster-4-ipmi" = "192.168.1.43";
                    "cluster-5-ipmi.wl.mort.is" = "192.168.1.40";
                    "cluster-5-ipmi" = "192.168.1.40";
                    "cluster-6-ipmi.wl.mort.is" = "192.168.1.21";
                    "cluster-6-ipmi" = "192.168.1.21";
                    "cluster-7-ipmi.wl.mort.is" = "192.168.1.19";
                    "cluster-7-ipmi" = "192.168.1.19";
                    "cluster-8-ipmi.wl.mort.is" = "192.168.1.85";
                    "cluster-8-ipmi" = "192.168.1.85";

                    ## computer cluster / secure
                    "cluster-1-control.wl.mort.is" = "192.168.2.70";
                    "cluster-1-control" = "192.168.2.70";
                    "cluster-1.wl.mort.is" = "192.168.2.70";
                    "cluster-1" = "192.168.2.70";
                    "cluster-2-control.wl.mort.is" = "192.168.2.75";
                    "cluster-2-control" = "192.168.2.75";
                    "cluster-2.wl.mort.is" = "192.168.2.75";
                    "cluster-2" = "192.168.2.75";
                    "cluster-3-control.wl.mort.is" = "192.168.2.83";
                    "cluster-3-control" = "192.168.2.83";
                    "cluster-3.wl.mort.is" = "192.168.2.83";
                    "cluster-3" = "192.168.2.83";
                    "cluster-4-control.wl.mort.is" = "192.168.2.33";
                    "cluster-4-control" = "192.168.2.33";
                    "cluster-4.wl.mort.is" = "192.168.2.33";
                    "cluster-4" = "192.168.2.33";
                    "cluster-5-control.wl.mort.is" = "192.168.2.85";
                    "cluster-5-control" = "192.168.2.85";
                    "cluster-5.wl.mort.is" = "192.168.2.85";
                    "cluster-5" = "192.168.2.85";
                    "cluster-6-control.wl.mort.is" = "192.168.2.63";
                    "cluster-6-control" = "192.168.2.63";
                    "cluster-6.wl.mort.is" = "192.168.2.63";
                    "cluster-6" = "192.168.2.63";
                    "cluster-7-control.wl.mort.is" = "192.168.2.29";
                    "cluster-7-control" = "192.168.2.29";
                    "cluster-7.wl.mort.is" = "192.168.2.29";
                    "cluster-7" = "192.168.2.29";
                    "cluster-8-control.wl.mort.is" = "192.168.2.82";
                    "cluster-8-control" = "192.168.2.82";
                    "cluster-8.wl.mort.is" = "192.168.2.82";
                    "cluster-8" = "192.168.2.82";

                    ## computer cluster / insecure
                    "cluster-1-media.wl.mort.is" = "192.168.3.71";
                    "cluster-1-media" = "192.168.3.71";
                    "cluster-2-media.wl.mort.is" = "192.168.3.76";
                    "cluster-2-media" = "192.168.3.76";
                    "cluster-3-media.wl.mort.is" = "192.168.3.84";
                    "cluster-3-media" = "192.168.3.84";
                    "cluster-4-media.wl.mort.is" = "192.168.3.34";
                    "cluster-4-media" = "192.168.3.34";
                    "cluster-5-media.wl.mort.is" = "192.168.3.86";
                    "cluster-5-media" = "192.168.3.86";
                    "cluster-6-media.wl.mort.is" = "192.168.3.62";
                    "cluster-6-media" = "192.168.3.62";
                    "cluster-7-media.wl.mort.is" = "192.168.3.30";
                    "cluster-7-media" = "192.168.3.30";
                    "cluster-8-media.wl.mort.is" = "192.168.3.83";
                    "cluster-8-media" = "192.168.3.83";

                    ## storage-1
                    "storage-1-control.wl.mort.is" = "192.168.2.38";
                    "storage-1-control" = "192.168.2.38";
                    "storage-1-idrac.wl.mort.is" = "192.168.1.59";
                    "storage-1-idrac" = "192.168.1.59";
                    "storage-1-media.wl.mort.is" = "192.168.3.35";
                    "storage-1-media" = "192.168.3.35";
                    "storage-1.wl.mort.is" = "192.168.2.38";
                    "storage-1" = "192.168.2.38";

                    # k8s services
                    ## secure / control apps
                    "alerts.wl.mort.is" = "192.168.2.225";
                    "auth.wl.mort.is" = "192.168.3.225";
                    "backup.wl.mort.is" = "192.168.2.225";
                    "cd.wl.mort.is" = "192.168.2.225";
                    "k8s.wl.mort.is" = "192.168.2.225";
                    "longhorn.wl.mort.is" = "192.168.2.225";
                    "monitor.wl.mort.is" = "192.168.2.225";
                    "network.wl.mort.is" = "192.168.3.225";
                    "prometheus.wl.mort.is" = "192.168.2.225";
                    "ss.wl.mort.is" = "192.168.3.225";

                    # secure / home apps
                    "birds.wl.mort.is" = "192.168.2.225";
                    "paperless.wl.mort.is" = "192.168.2.225";
                    "power.wl.mort.is" = "192.168.2.225";
                    "solar.wl.mort.is" = "192.168.2.225";
                    "vacuum.wl.mort.is" = "192.168.2.225";

                    # secure / media apps
                    "emu.wl.mort.is" = "192.168.2.225";
                    "index.wl.mort.is" = "192.168.2.225";
                    "movies.wl.mort.is" = "192.168.2.225";
                    "music.wl.mort.is" = "192.168.2.225";
                    "subs.wl.mort.is" = "192.168.2.225";
                    "sync.wl.mort.is" = "192.168.2.225";
                    "television.wl.mort.is" = "192.168.2.225";

                    # secure / media ingest apps
                    "autodl.wl.mort.is" = "192.168.2.225";
                    "download.wl.mort.is" = "192.168.2.225";
                    "processing.wl.mort.is" = "192.168.2.225";

                    # insecure / home apps
                    "home.wl.mort.is" = "192.168.3.225";
                    "protect.wl.mort.is" = "192.168.3.225";

                    # insecure / media apps
                    "files.wl.mort.is" = "192.168.3.225";
                    "media.wl.mort.is" = "192.168.3.225";
                    "nas.wl.mort.is" = "192.168.3.235";
                    "plex.wl.mort.is" = "192.168.3.230";
                    "syncthing.wl.mort.is" = "192.168.3.236";

                    # external apps
                    "boundlexx.wl.mort.is" = "192.168.3.225";
                    # "debug.wl.mort.is" = "192.168.3.225";
                    # "debug2.wl.mort.is" = "192.168.2.225";
                    # "debug3.wl.mort.is" = "192.168.3.226";

                    # game servers
                    "satisfactory.wl.mort.is" = "192.168.3.240";

                    # IoT / NoT devices
                    "awair-1.wl.mort.is" = "192.168.52.93";
                    "enphase.wl.mort.is" = "192.168.52.75";
                    "printer.wl.mort.is" = "192.168.52.20";
                    "span.wl.mort.is" = "192.168.52.49";
                    "vacuum-1.wl.mort.is" = "192.168.52.11";
                    "vacuum-2.wl.mort.is" = "192.168.52.55";
                };
                zone = ''
                    $ORIGIN wl.mort.is.
                '';
            };

            prometheus.enable = true;

            queryLog = {
                # optional one of: mysql, postgresql, csv, csv-client. If empty, log to console
                type = "mysql";
                # directory (should be mounted as volume in docker) for csv, db connection string for mysql/postgresql
                target = "blocky:dBocfpvqHekxWpqUGaEXyqjqurNosoHM@tcp(localhost:3306)/blocky?charset=utf8mb4&parseTime=True&loc=Local";
                #postgresql target: postgres://user:password@db_host_or_ip:5432/db_name
                # if > 0, deletes log files which are older than ... days
                logRetentionDays = 7;
                # optional: Max attempts to create specific query log writer, default: 3
                # creationAttempts = 1;
                # optional: Time between the creation attempts, default: 2s
                # creationCooldown = "2s"
                # optional: Which fields should be logged. You can choose one or more from: clientIP, clientName, responseReason, responseAnswer, question, duration. If not defined, it logs all fields
                # fields = [
                #     "clientIP"
                #     "duration"
                # ]
                # optional: Interval to write data in bulk to the external database, default: 30s
                # flushInterval = "30s"
            };
        };
    };
}
