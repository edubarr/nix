{ pkgs, ... }:
let
  immichEnv = "/srv/configs/immich/.env";

  backupConfigs = pkgs.writeShellScript "backup-configs" ''
    set -euo pipefail

    dumpDir="/srv/configs/immich/dump"
    ${pkgs.coreutils}/bin/install -d -m 0755 "$dumpDir"

    dbUser="$(${pkgs.gnugrep}/bin/grep -E '^POSTGRES_USER=' ${immichEnv} | ${pkgs.coreutils}/bin/cut -d= -f2- || true)"
    dbName="$(${pkgs.gnugrep}/bin/grep -E '^POSTGRES_DB=' ${immichEnv} | ${pkgs.coreutils}/bin/cut -d= -f2- || true)"
    : "''${dbUser:=postgres}"
    : "''${dbName:=immich}"

    ${pkgs.docker}/bin/docker exec immich-database \
      pg_dump -U "$dbUser" "$dbName" | ${pkgs.gzip}/bin/gzip > "$dumpDir/immich.sql.gz"

    dest="/media/hd4/bkp/hydra/srv/configs"
    ${pkgs.coreutils}/bin/install -d -m 0755 "$dest"
    ${pkgs.rsync}/bin/rsync -aHAX --delete --numeric-ids \
      --exclude='immich/postgres' \
      --exclude='immich/model-cache' \
      --backup --backup-dir="/media/hd4/.backup/configs/$(date +%F)" \
      /srv/configs/ "$dest/"
  '';

  backupImmich = pkgs.writeShellScript "backup-immich" ''
    set -euo pipefail

    dest="/media/hd4/bkp/hydra/media/hd3/immich"
    ${pkgs.coreutils}/bin/install -d -m 0755 "$dest"
    ${pkgs.rsync}/bin/rsync -aHAX --delete --numeric-ids \
      --backup --backup-dir="/media/hd4/.backup/immich/$(date +%F)" \
      /media/hd3/immich/ "$dest/"
  '';

  backupMirror = pkgs.writeShellScript "backup-mirror" ''
    set -euo pipefail

    ${pkgs.coreutils}/bin/install -d -m 0755 /media/hd4/bkp /media/hd5/bkp

    ${pkgs.rsync}/bin/rsync -aHAX --delete --numeric-ids \
      --backup --backup-dir="/media/hd5/.backup/bkp/$(date +%F)" \
      /media/hd4/bkp/ /media/hd5/bkp/
  '';
in
{
  systemd.services.backup-configs = {
    description = "Mirror /srv/configs to the hd4 backup disk";
    after = [
      "docker-immich-database.service"
      "media-hd4.mount"
    ];
    wants = [
      "docker-immich-database.service"
      "media-hd4.mount"
    ];
    requires = [
      "media-hd4.mount"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backupConfigs}";
    };
  };

  systemd.timers.backup-configs = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:30:00";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };

  systemd.services.backup-immich = {
    description = "Mirror the Immich library to the hd4 backup disk";
    after = [
      "media-hd3.mount"
      "media-hd4.mount"
    ];
    wants = [
      "media-hd3.mount"
      "media-hd4.mount"
    ];
    requires = [
      "media-hd3.mount"
      "media-hd4.mount"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backupImmich}";
    };
  };

  systemd.timers.backup-immich = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 04:00:00";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };

  systemd.services.backup-mirror = {
    description = "Mirror the hd4 Samba backup folder to hd5";
    after = [
      "backup-configs.service"
      "backup-immich.service"
      "media-hd4.mount"
      "media-hd5.mount"
    ];
    wants = [
      "media-hd4.mount"
      "media-hd5.mount"
    ];
    requires = [
      "media-hd4.mount"
      "media-hd5.mount"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backupMirror}";
    };
  };

  systemd.timers.backup-mirror = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 04:30:00";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };
}
