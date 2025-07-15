const express = require('express');
const app = express();
const port = 3000;
const mongoose = require('mongoose');
const candidateRoutes = require('./routes/CandidateRoutes');
const employerRoutes = require('./routes/EmployerRoutes');
const groupRoutes = require('./routes/GroupRoutes');
const http = require('http');
const server = http.createServer(app);
const {Server} = require('socket.io');
const registerSocketHandlers = require('./socketHandlers/socket.js');
const JWT_SECRET = process.env.JWT_SECRET; 
const jwt = require('jsonwebtoken');

require('dotenv').config();

const uri = process.env.MONGODB_URI;
mongoose.connect(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('✅ MongoDB connected'))
.catch((err) => console.error('❌ MongoDB connection error:', err));
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

app.use(express.json());
app.get('/', (req, res) => {
    res.send('🚀 API is running and MongoDB is connected!');
  });
  app.use('/candidate', candidateRoutes);
  app.use('/employer', employerRoutes);
  app.use('/job', require('./routes/JobRoutes'));
  app.use('/group', groupRoutes);

  io.use((socket, next) => {
    const token = socket.handshake.query.token; // Comes from frontend socket config

  if (!token) {
    console.log('No token provided in handshake');
    return next(new Error('No token, authorization denied'));
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    console.log('Decoded user from socket:', decoded);
    socket.user = decoded; 
    console.log('✅ Socket authenticated user:', socket.user);
    next();
  } catch (error) {
    console.error('❌ Token verification failed in Socket.IO:', error.message);
    next(new Error('Token is not valid'));
  }
});
  io.on('connection', (socket) => {
    console.log('🔗 New client connected:', socket.id);
    registerSocketHandlers(socket, io);
  });
  
  
server.listen(3000, '0.0.0.0', () => {
  console.log(`Server is running at http://0.0.0.0:3000`);
});
