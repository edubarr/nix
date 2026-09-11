{ pkgs, ... }:
let
  immichEnv = "/srv/configs/immich/.env";
  backupRetentionDays = 30;

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

    dailyDir="$dumpDir/history/daily"
    weeklyDir="$dumpDir/history/weekly"
    ${pkgs.coreutils}/bin/install -d -m 0755 "$dailyDir" "$weeklyDir"

    ${pkgs.coreutils}/bin/cp -f "$dumpDir/immich.sql.gz" "$dailyDir/immich-$(date +%F).sql.gz"
    weekFile="$weeklyDir/immich-$(date +%G-W%V).sql.gz"
    if [ ! -f "$weekFile" ]; then
      ${pkgs.coreutils}/bin/cp -f "$dumpDir/immich.sql.gz" "$weekFile"
    fi

    ${pkgs.findutils}/bin/find "$dailyDir" -maxdepth 1 -type f -name 'immich-*.sql.gz' \
      | ${pkgs.coreutils}/bin/sort -r | ${pkgs.coreutils}/bin/tail -n +8 \
      | ${pkgs.findutils}/bin/xargs -r ${pkgs.coreutils}/bin/rm -f
    ${pkgs.findutils}/bin/find "$weeklyDir" -maxdepth 1 -type f -name 'immich-*.sql.gz' \
      | ${pkgs.coreutils}/bin/sort -r | ${pkgs.coreutils}/bin/tail -n +5 \
      | ${pkgs.findutils}/bin/xargs -r ${pkgs.coreutils}/bin/rm -f

    dest="/media/hd4/bkp/hydra/srv/configs"
    ${pkgs.coreutils}/bin/install -d -m 0755 "$dest"
    ${pkgs.rsync}/bin/rsync -aHAX --delete --numeric-ids \
      --exclude='immich/postgres' \
      --exclude='immich/model-cache' \
      --exclude='immich/dump' \
      --backup --backup-dir="/media/hd4/.backup/configs/$(date +%F)" \
      /srv/configs/ "$dest/"
    ${pkgs.rsync}/bin/rsync -aHAX --delete --numeric-ids \
      /srv/configs/immich/dump/ "$dest/immich/dump/"

    if [ -d /media/hd4/.backup/configs ]; then
      ${pkgs.findutils}/bin/find /media/hd4/.backup/configs -mindepth 1 -maxdepth 1 -type d \
        -mtime +${toString backupRetentionDays} -exec ${pkgs.coreutils}/bin/rm -rf {} +
    fi
  '';

  backupImmich = pkgs.writeShellScript "backup-immich" ''
    set -euo pipefail

    dest="/media/hd4/bkp/hydra/media/hd3/immich"
    ${pkgs.coreutils}/bin/install -d -m 0755 "$dest"
    ${pkgs.rsync}/bin/rsync -aHAX --delete --numeric-ids \
      --backup --backup-dir="/media/hd4/.backup/immich/$(date +%F)" \
      /media/hd3/immich/ "$dest/"

    if [ -d /media/hd4/.backup/immich ]; then
      ${pkgs.findutils}/bin/find /media/hd4/.backup/immich -mindepth 1 -maxdepth 1 -type d \
        -mtime +${toString backupRetentionDays} -exec ${pkgs.coreutils}/bin/rm -rf {} +
    fi
  '';

  backupMirror = pkgs.writeShellScript "backup-mirror" ''
    set -euo pipefail

    ${pkgs.coreutils}/bin/install -d -m 0755 /media/hd4/bkp /media/hd5/bkp

    ${pkgs.rsync}/bin/rsync -aHAX --delete --numeric-ids \
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
