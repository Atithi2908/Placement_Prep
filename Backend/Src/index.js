const express = require('express');
const app = express();
const port = 3000;
const mongoose = require('mongoose');
const candidateRoutes = require('./routes/CandidateRoutes');
const employerRoutes = require('./routes/EmployerRoutes');
const jobRoutes = require('./routes/JobRoutes');
mongoose.connect('mongodb+srv://Atithi:jbIPL9kzW2yICjN2@cluster0.3gndcpo.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('✅ MongoDB connected'))
.catch((err) => console.error('❌ MongoDB connection error:', err));

app.use(express.json());
app.get('/', (req, res) => {
    res.send('🚀 API is running and MongoDB is connected!');
  });
  app.use('/candidate', candidateRoutes);
  app.use('/employer', employerRoutes);
  app.use('/job', require('./routes/JobRoutes'));
  
app.listen(3000, '0.0.0.0', () => {
  console.log(`Server is running at http://0.0.0.0:3000`);
});
