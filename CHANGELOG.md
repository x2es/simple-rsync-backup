CHANGELOG
=========

## v1.3.0

 * add `snapshot.sh` tool
 * make backup with snapshot layout when snapshot.sh tool present in source directory
 * invoke snapshot tool on storage after backup (locally or via ssh)
 * fix `~/` expansion issue
 * create target storage unless exist (mkdir -p, unless `--mkpath` become common in distros)

## v1.2.0

 * allow local backup by commenting BACKUP_SERVER=
 * auto suggest container name, introduce "storage" term
 * add --hard-links option
 * append container name by trailing slash "/"
 * skip sending backup.log for --dry-run
 * allow custom rsync args by CUSTOM_ARGS= or by passing shell arguments

