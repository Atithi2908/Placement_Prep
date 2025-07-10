const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');    
const Candidate = require('../models/Candidate');
const Application = require('../models/Application');
const Job = require('../models/Job');
const Question = require('../models/question');
const dotenv = require('dotenv');
dotenv.config(); 
const jwtSecret = process.env.JWT_SECRET;
const Task = require('../models/Task');

const axios = require('axios');
const signup = async (req, res) => {
    const { name, email, password } = req.body;
    try {
        const existingCandidate = await Candidate.findOne({ email });
        if (existingCandidate) {
            return res.status(400).json({ message: 'Candidate already exists' });
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        const newCandidate = new Candidate({
            name,
            email,
            password: hashedPassword,

        })
        await newCandidate.save();
        res.status(201).json({ message: 'Candidate registered successfully' });
    } catch (error) {
        console.error('Error during signup:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

const signin = async (req, res) => {
    const { email, password } = req.body;
    console.log('Signin request received with email:', email);
    try {
        const candidate = await Candidate.findOne({ email });
        if (!candidate) {
            return res.status(400).json({ message: 'Candidate not found' });
            console.log('Candidate not found for email:', email);
        }
        const isMatch = await bcrypt.compare(password, candidate.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid credentials' });
            console.log('Invalid credentials for email:', email);
        }
        const token = jwt.sign({
            id: candidate._id,
            email: candidate.email,
        }, jwtSecret, {
        });
        console.log('Signin successful for email:', email);
        res.status(200).json({ token, candidateId: candidate._id, candidateName: candidate.name });
    } catch (error) {
        console.error('Error during signin:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};


const getdetails = async (req, res) => {
    try {
        const candidate = await Candidate.findOne({ email: req.user.email });
        if (!candidate) {
            return res.status(400).json({ message: 'Candidate not found' });
        }
        res.status(200).json({ candidate });
    }
    catch (error) {
        console.error('Error fetching candidate details:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

const apply = async (req, res) => {
    try {
        const { job_Id } = req.body;
        const userId = req.user.id;


        const jobExists = await Job.findById(job_Id);
        if (!jobExists) {
            return res.status(404).json({ message: 'Job not found' });
        }


        const alreadyApplied = await Application.findOne({ candidate: userId, job: job_Id });
        if (alreadyApplied) {
            return res.status(400).json({ message: 'You have already applied for this job' });
        }


        const newApplication = new Application({
            job: job_Id,
            candidate: userId
        });
        console.log('Applying to job with data:', newApplication);

        await newApplication.save();

        res.status(201).json({ message: 'Application submitted successfully' });
    } catch (error) {
        console.error('Error applying to job:', error);
        res.status(500).json({ message: 'Server error' });
    }
};

const addTasks = async (req, res) => {
    try {
        const userId = req.user.id;
        const { date, title } = req.body;  // Get title and date
        const taskObj = { title, completed: false };  // Create task object

        let taskDoc = await Task.findOne({ userId, Date: new Date(date) });

        if (taskDoc) {
            taskDoc.Task.push(taskObj);  // Push single task object
            await taskDoc.save();
            return res.status(200).json({ message: 'Task added successfully', task: taskDoc });
        } else {
            const newTaskDoc = new Task({
                userId,
                Date: new Date(date),
                Task: [taskObj],  // Initialize with array containing the task
            });
            await newTaskDoc.save();
            return res.status(201).json({ message: 'Task created successfully', task: newTaskDoc });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

const getTasks = async (req, res) => {
  const date = req.query.date;
  const userId = req.user.id;

  try {
    if (!date) {
      return res.status(400).json({ message: 'Date is required' });
    }

    let taskDoc = await Task.findOne({ userId, Date: new Date(date) });

    if (!taskDoc) {
      // No task document found → return empty array
      return res.status(200).json({ tasks: [] });
    }

    // Return the tasks array from the document
    res.status(200).json({ tasks: taskDoc.Task });
  } catch (error) {
    console.error('Error fetching tasks:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

const markTaskDone = async (req, res) => {
  try {
    const userId = req.user.id;
   
    const { date,id } = req.body;

    
    const taskDoc = await Task.findOne({ userId, Date: new Date(date) });
    if (!taskDoc) {
      return res.status(404).json({ message: 'No tasks found for this date' });
    }

    
   const taskItem = taskDoc.Task.id(id);
    if (!taskItem) {
      return res.status(404).json({ message: 'Task not found' });
    }

    
    taskItem.completed = true;

    await taskDoc.save();
    return res.status(200).json({ message: 'Task marked as done', task: taskItem });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const markTaskUndone = async (req, res) => {
    try{
        console.log('Marking task as undone');
        const userId = req.user.id;
        const { date, id} = req.body;
        const taskDoc = await Task.findOne({ userId, Date: new Date(date) });
        if (!taskDoc) {
            return res.status(404).json({ message: 'No tasks found for this date' });
        }
        const taskItem = taskDoc.Task.id(id);
        console.log('Task item found:', taskItem);
        if (!taskItem) {
            return res.status(404).json({ message: 'Task not found' });
        }
        taskItem.completed = false;
        await taskDoc.save();
        res.status(200).json({ message: 'Task marked as undone', task: taskItem });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

const dailyQuestion = async (req, res) => {
    try {
        console.log('Fetching daily question');
        const question = await Question.findOne().sort({ _id: -1 });
        if (!question) {
            return res.status(404).json({ message: 'No question found for today' });
        }
        res.status(200).json({ question });
    } catch (error) {
        console.error('Error fetching daily question:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

const generateQuiz = async (req, res) => {
    const topic = req.query.topic;
    const count = req.query.count || 5; 
    console.log('Request to generate quiz');
    console.log('your api key is:', process.env.OPENROUTER_API_KEY);
    if (!topic) {
  return res.status(400).json({ message: 'Topic is required' });
}
    try{
const response = await axios.post('https://openrouter.ai/api/v1/chat/completions',
{
    model: "deepseek/deepseek-chat-v3-0324:free",
    messages: [
        {
            role: "system",
            content: "You are a helpful assistant that generates quiz questions based on the given topic."
        },
        {
            role: "user",
content: `Generate ${count} MCQs on the topic of ${topic}. Return only a JSON array with no explanation or markdown. Format:
[
  {
    "question": "...",
    "options": ["...", "...", "...", "..."],
    "answer": "..."
  }
]`
        }
    ],
}
,{
    headers: {
        'Authorization': `Bearer ${process.env.OPENROUTER_API_KEY}`,
        'Content-Type': 'application/json'
    }
});

 
  const message = response.data.choices[0].message.content;

const cleanMessage = message.replace(/```json|```/g, '').trim();

const mcqs = JSON.parse(cleanMessage);
    res.json({ mcqs });



}catch (error) {
        console.error('Error generating quiz:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}
module.exports = {
    signup,
    signin,
    getdetails,
    apply,
    addTasks,
    getTasks,
markTaskDone,
    markTaskUndone,
    dailyQuestion,
    generateQuiz
};