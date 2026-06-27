# Verificar si PostgreSQL esta Instalado

```bash
psql --version
```

si esta instalado, veras algo similar a:

psql ( postgreSQL ) 17.0

si no sale, procederemos a instalar la base de datos.

# Instalación

1. Actualizamos repositorios linux

```bash
sudo apt update
```

---

2. ¿ Como instalar PostgreSQL ?

```bash
sudo apt install postgresql postgresql-contrib -y
```

---

3. Verificamos que el servicio este activo:

```bash
sudo systemct1 status postgresql
```

---

# Comprobamos que este instalado exitosamente

```bash
psql --version
```
