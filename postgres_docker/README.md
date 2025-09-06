# PostgreSQL Docker Compose Setup

A complete PostgreSQL development environment with Docker Compose, including PostgreSQL database, Adminer web interface, and comprehensive sample data initialization.

## 🚀 Quick Start

1. **Navigate to the project directory**
   ```bash
   cd postgres_docker
   ```

2. **Start the services**
   ```bash
   docker-compose up -d
   ```

3. **Access the applications**
   - **Adminer**: http://localhost:8080
   - **PostgreSQL**: localhost:5432

## 📋 Services Overview

### PostgreSQL Database
- **Image**: `postgres:15-alpine`
- **Port**: `5432`
- **Container Name**: `postgres-server`
- **Database**: `myapp`
- **Credentials**: 
  - Username: `admin`
  - Password: `password123`

### Adminer (Web UI)
- **Image**: `adminer:latest`
- **Port**: `8080`
- **Container Name**: `adminer-admin`
- **Theme**: Hydra (modern dark theme)
- **Login**:
  - System: `PostgreSQL`
  - Server: `postgres`
  - Username: `admin`
  - Password: `password123`
  - Database: `myapp`

## 📊 Database Schema

The database is automatically initialized with a comprehensive schema:

### Tables Created:

#### 1. **Users Table**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    age INTEGER CHECK (age > 0 AND age < 150),
    role VARCHAR(50) NOT NULL,
    skills TEXT[],
    address JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);
```

#### 2. **Products Table**
```sql
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    category VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    in_stock BOOLEAN DEFAULT true,
    quantity INTEGER DEFAULT 0 CHECK (quantity >= 0),
    specifications JSONB,
    tags TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

#### 3. **Orders Table**
```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id VARCHAR(50) UNIQUE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    shipping_address JSONB,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    delivery_date TIMESTAMP WITH TIME ZONE,
    notes TEXT
);
```

#### 4. **Order Items Table** (Normalized)
```sql
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    product_name VARCHAR(200) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    total_price DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);
```

#### 5. **Categories Table**
```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parent_id UUID REFERENCES categories(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

## 🔧 Docker Compose Commands

### Basic Operations
```bash
# Start all services in background
docker-compose up -d

# Start all services with logs visible
docker-compose up

# Stop all services
docker-compose down

# Stop and remove volumes (deletes all data)
docker-compose down -v

# Restart services
docker-compose restart

# View logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# View logs for specific service
docker-compose logs postgres
docker-compose logs adminer
```

### Service Management
```bash
# Check service status
docker-compose ps

# Execute commands in PostgreSQL container
docker-compose exec postgres psql -U admin -d myapp

# Execute shell in PostgreSQL container
docker-compose exec postgres bash

# Execute shell in Adminer container
docker-compose exec adminer sh
```

## 🗄️ Database Operations

### Connect via psql
```bash
# Connect to PostgreSQL from host (requires psql installed)
psql "postgresql://admin:password123@localhost:5432/myapp"

# Or connect from within container
docker-compose exec postgres psql -U admin -d myapp
```

### Sample Queries
```sql
-- List all tables
\dt

-- View users
SELECT * FROM users;

-- Find active users with their skills
SELECT name, email, role, skills FROM users WHERE is_active = true;

-- Products by category with pricing
SELECT name, category, brand, price, in_stock 
FROM products 
ORDER BY category, price;

-- Order summary with customer details
SELECT * FROM order_summary;

-- Users and their orders
SELECT 
    u.name, 
    u.email, 
    o.order_id, 
    o.total_amount, 
    o.status, 
    o.order_date
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
ORDER BY o.order_date DESC;

-- Products with JSONB queries
SELECT name, specifications->>'processor' as cpu, specifications->>'ram' as memory
FROM products 
WHERE specifications ? 'processor';

-- Search products using arrays
SELECT name, tags FROM products WHERE 'laptop' = ANY(tags);
```

## 📁 File Structure
```
postgres_docker/
├── docker-compose.yml          # Docker Compose configuration
├── init.sql                   # Database initialization script
└── README.md                  # This file
```

## 🔍 Database Features

### Extensions Enabled:
- **uuid-ossp**: UUID generation functions
- **pgcrypto**: Cryptographic functions

### Indexes Created:
- **Users**: email (unique), role, is_active
- **Products**: category, brand, price, name (full-text search)
- **Orders**: user_id, status, order_date
- **Order Items**: order_id, product_id

### Views:
- **order_summary**: Comprehensive order details with customer info

### Triggers:
- **Auto-update timestamps**: Automatically updates `updated_at` fields

### Data Types Used:
- **UUID**: Primary keys for better distribution
- **JSONB**: Flexible document storage for addresses and specifications
- **Arrays**: For skills and tags
- **Constraints**: Data validation and referential integrity
- **Generated Columns**: Calculated total prices

## 🌐 Adminer Web Interface

### Features:
1. **Database Browser**: Navigate tables, views, and schemas
2. **Query Editor**: Execute SQL queries with syntax highlighting
3. **Data Editor**: Insert, update, delete records through UI
4. **Schema Designer**: Visualize table relationships
5. **Import/Export**: CSV, SQL, and other formats
6. **User Management**: Manage database users and permissions

### Access Steps:
1. Open http://localhost:8080
2. Select **PostgreSQL** as system
3. Enter connection details:
   - **Server**: `postgres`
   - **Username**: `admin`
   - **Password**: `password123`
   - **Database**: `myapp`
4. Click **Login**

## 🔧 Configuration

### Environment Variables

You can modify these in `docker-compose.yml`:

```yaml
# PostgreSQL Configuration
POSTGRES_DB: myapp
POSTGRES_USER: admin
POSTGRES_PASSWORD: password123
POSTGRES_INITDB_ARGS: --encoding=UTF-8 --lc-collate=C --lc-ctype=C

# Adminer Configuration
ADMINER_DEFAULT_SERVER: postgres
ADMINER_DESIGN: hydra
```

### Port Configuration

Default ports (can be changed in docker-compose.yml):
- PostgreSQL: `5432:5432`
- Adminer: `8080:8080`

## 📝 Data Persistence

- Database data is stored in Docker volume: `postgres-data`
- Data persists between container restarts
- To reset all data: `docker-compose down -v`

## 🛠️ Troubleshooting

### Common Issues:

1. **Port already in use**
   ```bash
   # Check what's using the port
   netstat -an | findstr :5432
   # Change ports in docker-compose.yml
   ```

2. **Cannot connect to PostgreSQL**
   ```bash
   # Check if containers are running
   docker-compose ps
   # Check logs for errors
   docker-compose logs postgres
   ```

3. **Adminer not loading**
   ```bash
   # Wait for PostgreSQL to be healthy
   docker-compose logs adminer
   ```

4. **Permission denied errors**
   ```bash
   # Reset database completely
   docker-compose down -v
   docker-compose up -d
   ```

5. **Init script not running**
   ```bash
   # Ensure fresh start
   docker-compose down -v
   docker volume prune
   docker-compose up -d
   ```

## 🚀 Development Tips

1. **Custom Data**: Modify `init.sql` to add your own schema and data
2. **Backup**: Use `pg_dump` to backup your database
3. **Performance**: Monitor queries using Adminer's explain feature
4. **Security**: Change default passwords for production
5. **Extensions**: Add more PostgreSQL extensions as needed

## 📊 Sample Data Overview

### Users (6 records):
- John Doe (Developer) - JavaScript, Python, PostgreSQL, Docker
- Jane Smith (Designer) - UI/UX, Figma, Adobe Creative Suite
- Bob Johnson (Manager) - Leadership, Project Management
- Alice Brown (Data Scientist) - Python, R, Machine Learning
- Charlie Wilson (DevOps) - Docker, Kubernetes, AWS
- Test User (Tester) - Testing, QA, Automation (inactive)

### Products (6 records):
- MacBook Pro 16" ($2499.99) - Electronics
- Wireless Gaming Mouse ($79.99) - Electronics
- Smart Coffee Maker ($199.99) - Home & Kitchen
- The Art of PostgreSQL ($45.99) - Books
- Running Shoes Pro ($129.99) - Sports & Outdoors (out of stock)
- Bluetooth Headphones ($249.99) - Electronics

### Orders (3 records):
- John's order: MacBook + Mouse (delivered)
- Jane's order: Coffee Maker + Headphones (shipped)
- Alice's order: PostgreSQL Book (pending)

### Categories (5 records):
- Electronics, Home & Kitchen, Books, Clothing, Sports & Outdoors

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Happy coding with PostgreSQL! 🐘**

For more PostgreSQL resources:
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Adminer Documentation](https://www.adminer.org/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
