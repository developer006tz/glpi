# GLPI Deployment Guide

## 🚀 Deployment Options

### Option 1: Deploy with Built-in Database (Recommended for Testing)

Use the default `docker-compose.yaml` which includes both GLPI app and MariaDB database.

**Environment Variables:**
```env
TIMEZONE=Africa/Dar_es_Salaam
DB_HOST=db
DB_PORT=3306
DB_DATABASE=glpi
DB_USER=glpi
DB_PASSWORD=your_secure_password
DB_ROOT_PASSWORD=your_root_password
```

**Deploy:**
```bash
docker-compose up -d
```

**Note:** The application exposes port 80 internally. Use Dokploy's domain/proxy settings to route traffic to your application.

---

### Option 2: Deploy with External Database (Recommended for Production)

Use `docker-compose.external-db.yaml` when you have a separate database server.

**Environment Variables:**
```env
TIMEZONE=Africa/Dar_es_Salaam
DB_HOST=your-db-server.com
DB_PORT=3306
DB_DATABASE=glpi
DB_USER=glpi
DB_PASSWORD=your_secure_password
```

**Deploy:**
```bash
docker-compose -f docker-compose.external-db.yaml up -d
```

---

## 📦 Dokploy Deployment

### Step 1: Set Environment Variables in Dokploy

Go to your application settings and add:

**For Built-in Database:**
```
TIMEZONE=Africa/Dar_es_Salaam
DB_HOST=db
DB_PASSWORD=your_secure_password
DB_ROOT_PASSWORD=your_root_password
```

**For External Database (Dokploy MySQL Service):**
```
TIMEZONE=Africa/Dar_es_Salaam
DB_HOST=your-dokploy-mysql-host
DB_PORT=3306
DB_DATABASE=glpi
DB_USER=glpi
DB_PASSWORD=your_db_password
```

### Step 2: Configure Domain & Proxy

In Dokploy's application settings:
1. Go to **Domains** section
2. Add your domain (e.g., `glpi.yourdomain.com`)
3. Enable **SSL/TLS** (recommended)
4. Set **Container Port**: `80`
5. Dokploy's Traefik proxy will automatically route traffic to your app

### Step 3: Deploy

Dokploy will automatically:
- Clone your GitHub repository
- Build the Docker image
- Start the containers
- Create persistent volumes
- Configure reverse proxy routing

---

## 🔧 Database Connection Parameters

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | `db` | Database hostname (use `db` for local, or external host) |
| `DB_PORT` | `3306` | Database port |
| `DB_DATABASE` | `glpi` | Database name |
| `DB_USER` | `glpi` | Database username |
| `DB_PASSWORD` | `glpi` | Database password |
| `DB_ROOT_PASSWORD` | - | Only needed for local database container |

---

## 🌍 Timezone

Set your timezone using the `TIMEZONE` environment variable:

**Examples:**
- Africa/Dar_es_Salaam (Tanzania)
- Africa/Nairobi (Kenya)
- Europe/Paris (France)
- America/New_York (USA - Eastern)

[Full timezone list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

---

## 📂 Persistent Volumes

The following directories are persisted:

- `/var/www/html/files` - Uploaded files and documents
- `/var/www/html/config` - GLPI configuration
- `/var/www/html/marketplace` - Installed plugins

---

## 🔐 Security Recommendations

1. **Change default passwords** - Never use default passwords in production
2. **Use strong passwords** - Mix of letters, numbers, and special characters
3. **Enable HTTPS** - Use a reverse proxy (Nginx, Traefik) with SSL certificates
4. **Regular backups** - Backup both database and volumes
5. **Keep updated** - Regularly update GLPI and Docker images

---

## 🩺 Health Checks

Both app and database have health checks configured:

**App Health Check:**
- Endpoint: `http://localhost/`
- Interval: 30 seconds
- Timeout: 10 seconds

**Database Health Check:**
- Command: `healthcheck.sh --connect --innodb_initialized`
- Interval: 10 seconds
- Timeout: 5 seconds

---

## 📝 First Time Setup

After deployment, access GLPI at `http://your-server-ip` and complete the installation wizard:

1. Select language
2. Accept license
3. Database configuration will use the environment variables
4. Create admin account
5. Complete setup

Default database connection during installation:
- **Host**: Value from `DB_HOST` environment variable
- **Database**: Value from `DB_DATABASE` environment variable
- **User**: Value from `DB_USER` environment variable
- **Password**: Value from `DB_PASSWORD` environment variable

---

## 🆘 Troubleshooting

**Database connection failed:**
- Check `DB_HOST` is correct
- Verify database credentials
- Ensure database server is accessible

**Permission errors:**
- Check volume permissions
- Ensure www-data user has access

**View logs:**
```bash
docker-compose logs -f app
docker-compose logs -f db
```

**Restart services:**
```bash
docker-compose restart
```
