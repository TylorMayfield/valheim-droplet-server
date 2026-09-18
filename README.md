# Valheim on a DigitalOcean Droplet

The companion files for the [Valheim Droplet guide](https://www.tylor.nz/content/deploy-valheim-server-digitalocean). They run the official dedicated-server tool with SteamCMD, systemd, a controlled update, and an offline archive.

This is for a small group that can administer an Ubuntu server. It does not add mods or a web panel. Use the guide for the DigitalOcean firewall, SSH, player join check, and restoration test.

This README contains an affiliate link. If you sign up through it, I may earn a commission at no extra cost to you. If a Droplet fits your group, [Visit DigitalOcean](https://www.tylor.nz/go/digitalocean?utm_source=github&utm_medium=affiliate&utm_campaign=digitalocean-guides&utm_content=deploy-valheim-server-digitalocean&product=droplets&placement=companion-readme&variant=valheim-server&locale=en). Check the current Droplet price, backups, and transfer costs in the control panel before you create a server.

## Install the files

After the guide has installed the Valheim server under `/opt/valheim/server` and created the `valheim` user:

```shell
git clone https://github.com/TylorMayfield/valheim-droplet-server.git /tmp/valheim-droplet-server
sudo install -d -m 750 /etc/valheim
sudo install -m 640 -o root -g valheim /tmp/valheim-droplet-server/config/server.env.example /etc/valheim/server.env
sudo nano /etc/valheim/server.env
sudo install -m 750 -o valheim -g valheim /tmp/valheim-droplet-server/scripts/start-valheim.sh /opt/valheim/server/start-valheim.sh
sudo install -m 644 -o root -g root /tmp/valheim-droplet-server/config/valheim.service /etc/systemd/system/valheim.service
sudo install -m 700 -o root -g root /tmp/valheim-droplet-server/scripts/backup-valheim-world /usr/local/sbin/backup-valheim-world
sudo install -m 700 -o root -g root /tmp/valheim-droplet-server/scripts/update-valheim-server /usr/local/sbin/update-valheim-server
sudo systemctl daemon-reload
sudo systemctl enable --now valheim
```

`SERVER_PUBLIC=0` means people join with the public Droplet IP and port through Valheim's Join IP screen. This direct-IP setup does not cover crossplay. Read the game server manual packaged with the currently installed tool before adding `-crossplay`.

## Check, back up, and update

```shell
sudo systemctl status valheim --no-pager
sudo ss -ulnp | grep -E ':2456|:2457'
sudo /usr/local/sbin/backup-valheim-world
sudo /usr/local/sbin/update-valheim-server
```

The backup command stops a running server, archives the actual `SAVE_DIR` from `/etc/valheim/server.env`, lists the archive, and restarts the service even after an archive failure. Copy the resulting archive to private off-machine storage and test a restore before relying on it.

## Safety notes

- Do not commit `/etc/valheim/server.env`; it contains the server password.
- Do not run the Valheim service as root.
- Back up before updates and test a copied world before changing game or mod versions.
- This repository cannot prove that a live player can join your Droplet. Confirm it from a real client after opening UDP 2456 and 2457.
