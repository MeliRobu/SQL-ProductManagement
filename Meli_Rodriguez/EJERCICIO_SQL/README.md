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

## Sales Database — SQL Practice Project

A relational database modeling a small sales/invoicing system (customers, sales reps, products, categories, invoices, and payment methods), built with PostgreSQL. Includes schema creation, seed data, and a set of analytical queries (sales by client, by category, by payment method, top-selling products, etc.).

## Tech Stack


PostgreSQL 16 — relational database engine
Docker & Docker Compose — containerized, reproducible database environment
SQL — DDL (schema), DML (seed data), and DQL (analytical queries)
psql — CLI client for running and testing queries


## Project Structure

.
├── docker-compose.yml
├── init/
│   └── 01_schema.sql        # schema + seed data + queries (this script)
└── README.md

##Database Schema

TableDescriptioncitiesCities where clients and reps are locatedclientesCustomerscategoriasProduct categoriesproductosProducts and unit pricesrepresentante_ventasSales representativesmetodos_pagoPayment methodsdetalle_facturaInvoice headers (number, date, payment method)cliente_repreBridge table: client ↔ assigned sales repfacturacionInvoice line items (product, quantity, invoice)

## Getting Started

1. Prerequisites


Docker and Docker Compose installed.


2. docker-compose.yml

yamlversion: "3.9"
services:
  db:
    image: postgres:16
    container_name: sales_db
    restart: unless-stopped
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin
      POSTGRES_DB: sales_db
    ports:
      - "5432:5432"
    volumes:
      - db_data:/var/lib/postgresql/data
      - ./init:/docker-entrypoint-initdb.d

volumes:
  db_data:

Place the SQL script inside ./init/01_schema.sql — PostgreSQL's official image automatically runs any .sql file in /docker-entrypoint-initdb.d on first container start.

3. Run the database

bash# Start the container in the background
docker compose up -d

# Check the container is running
docker compose ps

# View logs (confirm schema/seed ran without errors)
docker compose logs -f db

4. Connect to the database

bash# Using psql inside the container
docker exec -it sales_db psql -U admin -d sales_db

# Or from your host machine (requires psql installed locally)
psql -h localhost -p 5432 -U admin -d sales_db

5. Run queries

Once connected via psql, run any of the analytical queries, e.g.:

sql\dt                          -- list all tables
SELECT * FROM clientes;      -- list all customers

Or run the full script directly without an interactive session:

bashdocker exec -i sales_db psql -U admin -d sales_db < init/01_schema.sql

6. Stop / reset the environment

bash# Stop containers (keeps data)
docker compose down

# Stop and remove volumes (fresh database next run)
docker compose down -v

Included Queries

The script implements the following analytical queries:


List all clients
Products with their category
Invoices issued per city
Total sales per client
Total sales per category
Invoices handled by each sales rep
Best-selling products (by units sold)
Branches (sucursales) and number of invoices managed
Sales filtered by a specific payment method
Total value of each invoice


Notes


facturacion stores one row per product per invoice, so queries joining it with detalle_factura or representante_ventas use GROUP BY/SUM or DISTINCT to avoid duplicated rows.
cliente_repre is the bridge table linking a client to their assigned sales rep — most cross-table queries pass through it.
Default credentials (admin / admin) are for local development only; change them before any non-local use.