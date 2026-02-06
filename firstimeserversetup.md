# First-time server setup (Hetzner)

Run these on a fresh server after you SSH in (e.g. `ssh recordsw` or `ssh root@89.167.40.199`). Use this if the server is recreated.

---

## 1. Install Docker and Docker Compose plugin

```bash
apt-get update && apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**What `install -m 0755 -d /etc/apt/keyrings` does:** Creates the directory `/etc/apt/keyrings` with permissions `0755` (owner rwx, group and others rx). Apt uses this path for repository signing keys (modern key storage). The `-d` means “create directory”; `-m 0755` sets the mode.

---

## 2. Create app dir and clone repo (hetzner branch)

```bash
mkdir -p ~/app
cd ~/app
git clone -b hetzner https://github.com/UkoHegdu/recordsw.git .
```

---

## 3. Create `.env`

```bash
nano ~/app/.env
```

Add at least: `NEON_DB_CONNECTION_STRING`, `JWT_SECRET`, and the Trackmania API vars (`LEAD_API`, `AUTH_API_URL`, `AUTHORIZATION`, `USER_AGENT`, `OCLIENT_ID`, `OCLIENT_SECRET`). See `backend/ENV.md`. Save: Ctrl+O, Enter, Ctrl+X.

---

## 4. Deploy

```bash
cd ~/app
chmod +x deploy/deploy.sh
./deploy/deploy.sh
```

App will be at **http://YOUR_SERVER_IP/** (port 80).

---

## Optional: SSH config on your machine

Add to `~/.ssh/config` so you can run `ssh recordsw`:

```
Host recordsw
  HostName 89.167.40.199
  User root
```

(Update the IP if the server gets a new one.)
