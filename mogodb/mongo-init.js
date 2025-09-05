// MongoDB initialization script
// This script runs when the container starts for the first time

// Switch to the myapp database
db = db.getSiblingDB('myapp');

// Create a users collection and insert sample data
db.users.insertMany([
  {
    _id: ObjectId(),
    name: 'John Doe',
    email: 'john.doe@example.com',
    age: 30,
    role: 'developer',
    skills: ['JavaScript', 'Python', 'MongoDB'],
    address: {
      street: '123 Main St',
      city: 'New York',
      country: 'USA'
    },
    createdAt: new Date(),
    isActive: true
  },
  {
    _id: ObjectId(),
    name: 'Jane Smith',
    email: 'jane.smith@example.com',
    age: 28,
    role: 'designer',
    skills: ['UI/UX', 'Figma', 'Adobe Creative Suite'],
    address: {
      street: '456 Oak Ave',
      city: 'San Francisco',
      country: 'USA'
    },
    createdAt: new Date(),
    isActive: true
  },
  {
    _id: ObjectId(),
    name: 'Bob Johnson',
    email: 'bob.johnson@example.com',
    age: 35,
    role: 'manager',
    skills: ['Leadership', 'Project Management', 'Strategy'],
    address: {
      street: '789 Pine Rd',
      city: 'Seattle',
      country: 'USA'
    },
    createdAt: new Date(),
    isActive: false
  }
]);

// Create a products collection and insert sample data
db.products.insertMany([
  {
    _id: ObjectId(),
    name: 'Laptop Pro',
    description: 'High-performance laptop for professionals',
    price: 1299.99,
    category: 'Electronics',
    brand: 'TechCorp',
    inStock: true,
    quantity: 25,
    specifications: {
      processor: 'Intel i7',
      ram: '16GB',
      storage: '512GB SSD',
      screen: '15.6 inch'
    },
    tags: ['laptop', 'professional', 'high-performance'],
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Wireless Mouse',
    description: 'Ergonomic wireless mouse with precision tracking',
    price: 29.99,
    category: 'Electronics',
    brand: 'MouseTech',
    inStock: true,
    quantity: 150,
    specifications: {
      connectivity: 'Bluetooth 5.0',
      battery: 'Rechargeable Li-ion',
      dpi: '1600',
      color: 'Black'
    },
    tags: ['mouse', 'wireless', 'ergonomic'],
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Coffee Maker',
    description: 'Automatic drip coffee maker with programmable timer',
    price: 89.99,
    category: 'Home & Kitchen',
    brand: 'BrewMaster',
    inStock: false,
    quantity: 0,
    specifications: {
      capacity: '12 cups',
      features: ['Programmable', 'Auto-shutoff', 'Keep warm'],
      material: 'Stainless steel',
      color: 'Silver'
    },
    tags: ['coffee', 'kitchen', 'appliance'],
    createdAt: new Date(),
    updatedAt: new Date()
  }
]);

// Create an orders collection and insert sample data
db.orders.insertMany([
  {
    _id: ObjectId(),
    orderId: 'ORD-001',
    userId: 'john.doe@example.com',
    items: [
      {
        productName: 'Laptop Pro',
        quantity: 1,
        price: 1299.99
      },
      {
        productName: 'Wireless Mouse',
        quantity: 2,
        price: 29.99
      }
    ],
    totalAmount: 1359.97,
    status: 'completed',
    shippingAddress: {
      street: '123 Main St',
      city: 'New York',
      country: 'USA',
      zipCode: '10001'
    },
    orderDate: new Date('2024-09-01'),
    deliveryDate: new Date('2024-09-05')
  },
  {
    _id: ObjectId(),
    orderId: 'ORD-002',
    userId: 'jane.smith@example.com',
    items: [
      {
        productName: 'Coffee Maker',
        quantity: 1,
        price: 89.99
      }
    ],
    totalAmount: 89.99,
    status: 'pending',
    shippingAddress: {
      street: '456 Oak Ave',
      city: 'San Francisco',
      country: 'USA',
      zipCode: '94102'
    },
    orderDate: new Date('2024-09-03'),
    deliveryDate: null
  }
]);

// Create indexes for better performance
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ role: 1 });
db.products.createIndex({ category: 1 });
db.products.createIndex({ name: "text", description: "text" });
db.orders.createIndex({ userId: 1 });
db.orders.createIndex({ status: 1 });

print('=== MongoDB Initialization Complete ===');
print('Created collections: users, products, orders');
print('Inserted sample data and created indexes');
print('Users count:', db.users.countDocuments());
print('Products count:', db.products.countDocuments());
print('Orders count:', db.orders.countDocuments());
