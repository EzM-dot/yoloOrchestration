const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const multer = require('multer');
const upload = multer();

const productRoute = require('./routes/api/productRoute');

// Connecting to the Database
const dbName = process.env.MONGODB_DATABASE || 'yolomy';
const username = process.env.MONGODB_USERNAME || 'username';
const password = process.env.MONGODB_PASSWORD || 'password';

// Define a URL to connect to the database
const MONGODB_URI = process.env.MONGODB_URI || 
  `mongodb://${username}:${password}@mongodb-service:27017/${dbName}?authSource=admin`;

// Connect to MongoDB
mongoose.connect(MONGODB_URI, {
  useNewUrlParser: true, 
  useUnifiedTopology: true,
  authSource: 'admin'
});

let db = mongoose.connection;

// Check Connection
db.once('open', ()=>{
    console.log('Database connected successfully')
})

// Check for DB Errors
db.on('error', (error)=>{
    console.log(error);
})

// Initializing express
const app = express()

// Body parser middleware
app.use(express.json())

// 
app.use(upload.array()); 

// Cors 
app.use(cors());

// Use Route
app.use('/api/products', productRoute)

// Define the PORT
const PORT = process.env.PORT || 4000

app.listen(PORT, ()=>{
    console.log(`Server listening on port ${PORT}`)
})
