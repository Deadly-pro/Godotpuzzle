const express = require('express');
const bodyParser = require('body-parser');
const session = require('express-session');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static('public'));
app.use(session({
    secret: 'your-secret-key',
    resave: false,
    saveUninitialized: true
}));

// Load questions data
const questions = JSON.parse(fs.readFileSync(path.join(__dirname, 'data', 'questions.json'), 'utf8'));

// Load or initialize users data
let users = [];
const usersPath = path.join(__dirname, 'data', 'users.json');
if (fs.existsSync(usersPath)) {
    users = JSON.parse(fs.readFileSync(usersPath, 'utf8'));
} else {
    fs.writeFileSync(usersPath, JSON.stringify(users));
}

app.post('/login', (req, res) => {
    const { username, password } = req.body;
    let user = users.find(u => u.username === username);
    if (!user) {
        user = { username, password, score: 0, lastLogin: new Date().toISOString() };
        users.push(user);
    } else {
        user.lastLogin = new Date().toISOString();
    }
    req.session.user = user;
    fs.writeFileSync(usersPath, JSON.stringify(users));
    res.json({ success: true });
});

app.get('/questions', (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ message: 'Not authenticated' });
    }
    res.json(questions.map(q => ({ id: q.id, question: q.question })));
});

app.get('/question/:id', (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ message: 'Not authenticated' });
    }
    const question = questions.find(q => q.id === parseInt(req.params.id));
    if (question) {
        res.json({ ...question, correctAnswer: undefined });
    } else {
        res.status(404).json({ message: 'Question not found' });
    }
});

app.get('/leaderboard', (req, res) => {
    const leaderboard = users
        .sort((a, b) => b.score - a.score)
        .slice(0, 10)
        .map(({ username, score }) => ({ username, score }));
    res.json(leaderboard);
});

app.post('/submit/:id', (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ message: 'Not authenticated' });
    }
    const { answer, timeSpent } = req.body;
    const question = questions.find(q => q.id === parseInt(req.params.id));
    
    let score = 0;
    if (question && answer === question.correctAnswer) {
        score = Math.max(question.points * (1 - timeSpent / 60), question.points * 0.1);
    }
    score = Math.round(score);
    
    const user = users.find(u => u.username === req.session.user.username);
    user.score += score;
    fs.writeFileSync(usersPath, JSON.stringify(users));
    
    res.json({ score, correct: answer === question.correctAnswer });
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});