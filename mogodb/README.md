# MongoDB Docker Compose Setup

A complete MongoDB development environment with Docker Compose, including MongoDB database, Mongo Express web interface, and sample data initialization.

## 🚀 Quick Start

1. **Clone or navigate to the project directory**
   ```bash
   cd mongodb_docker
   ```

2. **Start the services**
   ```bash
   docker-compose up -d
   ```

3. **Access the applications**
   - **Mongo Express**: http://localhost:8081
   - **MongoDB**: localhost:27017

## 📋 Services Overview

### MongoDB Database
- **Image**: `mongo:latest`
- **Port**: `27017`
- **Container Name**: `mongodb-server`
- **Database**: `myapp`
- **Credentials**: 
  - Username: `admin`
  - Password: `password123`

### Mongo Express (Web UI)
- **Image**: `mongo-express:latest`
- **Port**: `8081`
- **Container Name**: `mongo-express-admin`
- **Web Login**:
  - Username: `admin`
  - Password: `admin123`

## 📊 Sample Data

The database is automatically initialized with sample data including:

### Collections Created:

#### 1. **Users Collection** (3 documents)
```javascript
{
  name: "John Doe",
  email: "john.doe@example.com",
  age: 30,
  role: "developer",
  skills: ["JavaScript", "Python", "MongoDB"],
  address: { street, city, country },
  createdAt: Date,
  isActive: true
}
```

#### 2. **Products Collection** (3 documents)
```javascript
{
  name: "Laptop Pro",
  description: "High-performance laptop for professionals",
  price: 1299.99,
  category: "Electronics",
  brand: "TechCorp",
  inStock: true,
  quantity: 25,
  specifications: { processor, ram, storage, screen },
  tags: ["laptop", "professional", "high-performance"]
}
```

#### 3. **Orders Collection** (2 documents)
```javascript
{
  orderId: "ORD-001",
  userId: "john.doe@example.com",
  items: [{ productName, quantity, price }],
  totalAmount: 1359.97,
  status: "completed",
  shippingAddress: { street, city, country, zipCode },
  orderDate: Date,
  deliveryDate: Date
}
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
docker-compose logs mongodb
docker-compose logs mongo-express
```

### Service Management
```bash
# Check service status
docker-compose ps

# Execute commands in MongoDB container
docker-compose exec mongodb mongosh

# Execute commands in Mongo Express container
docker-compose exec mongo-express sh
```

## 🗄️ Database Operations

### Connect via MongoDB Shell
```bash
# Connect to MongoDB from host
mongosh "mongodb://admin:password123@localhost:27017/myapp?authSource=admin"

# Or connect from within container
docker-compose exec mongodb mongosh -u admin -p password123 --authenticationDatabase admin
```

### Sample Queries
```javascript
// Switch to myapp database
use myapp

// Find all users
db.users.find()

// Find active users
db.users.find({ isActive: true })

// Find products in Electronics category
db.products.find({ category: "Electronics" })

// Find completed orders
db.orders.find({ status: "completed" })

// Search products by text
db.products.find({ $text: { $search: "laptop" } })
```

## 📁 File Structure
```
mongodb_docker/
├── docker-compose.yml          # Docker Compose configuration
├── mongo-init.js              # Database initialization script
└── README.md                  # This file
```

## 🔍 Database Indexes

The following indexes are automatically created for better performance:

- **Users**: `email` (unique), `role`
- **Products**: `category`, text search on `name` and `description`
- **Orders**: `userId`, `status`

## 🌐 Web Interface Usage

### Mongo Express Features:
1. **Database Browser**: Navigate through databases and collections
2. **Document Viewer**: View and edit individual documents
3. **Query Interface**: Execute MongoDB queries through web UI
4. **Import/Export**: Backup and restore data
5. **User Management**: Manage database users and permissions

### Access Steps:
1. Open http://localhost:8081
2. Login with `admin` / `admin123`
3. Select `myapp` database
4. Browse collections: `users`, `products`, `orders`

## 🔧 Configuration

### Environment Variables

You can modify these in `docker-compose.yml`:

```yaml
# MongoDB Configuration
MONGO_INITDB_ROOT_USERNAME: admin
MONGO_INITDB_ROOT_PASSWORD: password123
MONGO_INITDB_DATABASE: myapp

# Mongo Express Configuration
ME_CONFIG_MONGODB_ADMINUSERNAME: admin
ME_CONFIG_MONGODB_ADMINPASSWORD: password123
ME_CONFIG_BASICAUTH_USERNAME: admin
ME_CONFIG_BASICAUTH_PASSWORD: admin123
```

### Port Configuration

Default ports (can be changed in docker-compose.yml):
- MongoDB: `27017:27017`
- Mongo Express: `8081:8081`

## 📝 Data Persistence

- Database data is stored in Docker volume: `mongodb-data`
- Data persists between container restarts
- To reset all data: `docker-compose down -v`

## 🛠️ Troubleshooting

### Common Issues:

1. **Port already in use**
   ```bash
   # Check what's using the port
   netstat -an | findstr :27017
   # Change ports in docker-compose.yml
   ```

2. **Cannot connect to MongoDB**
   ```bash
   # Check if containers are running
   docker-compose ps
   # Check logs for errors
   docker-compose logs mongodb
   ```

3. **Mongo Express not loading**
   ```bash
   # Wait for MongoDB to fully start first
   docker-compose logs mongo-express
   ```

4. **Reset database**
   ```bash
   # Stop and remove all data
   docker-compose down -v
   # Start fresh
   docker-compose up -d
   ```

## 🚀 Development Tips

1. **Custom Data**: Modify `mongo-init.js` to add your own sample data
2. **Backup**: Use `mongodump` to backup your data
3. **Scaling**: Add replica sets for production use
4. **Security**: Change default passwords for production
5. **Monitoring**: Add MongoDB monitoring tools

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Happy coding! 🎉**

For more MongoDB resources:
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Mongo Express GitHub](https://github.com/mongo-express/mongo-express)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
