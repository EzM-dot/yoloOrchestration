// Initialize the database and create a user with the correct privileges
db = db.getSiblingDB('yolodb');

db.createUser({
  user: 'username',
  pwd: 'password',
  roles: [
    { role: 'readWrite', db: 'yolodb' },
    { role: 'dbAdmin', db: 'yolodb' }
  ]
});

db.createCollection('products');
print('Database and user initialized successfully');
