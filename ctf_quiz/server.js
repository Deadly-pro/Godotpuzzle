const express = require('express');
const fs = require('fs').promises;
const path = require('path');
const app = express();
const port = 3000;

app.use(express.static('public'));
app.use(express.json());

async function readJsonFile(filename) {
    const data = await fs.readFile(path.join(__dirname, 'data', filename));
    return JSON.parse(data);
}

async function writeJsonFile(filename, data) {
    await fs.writeFile(
        path.join(__dirname, 'data', filename),
        JSON.stringify(data, null, 2)
    );
}

app.post('/api/login', async (req, res) => {
    const { name, email } = req.body;
    let users = await readJsonFile('users.json');
    
    let user = users.find(u => u.email === email);
    if (!user) {
        user = { name, email, score: 0, answeredQuestions: [] };
        users.push(user);
        await writeJsonFile('users.json', users);
    }
    
    res.json(user);
});

app.get('/api/questions', async (req, res) => {
    const questions = await readJsonFile('questions.json');
    res.json(questions);
});

app.post('/api/submit-answer', async (req, res) => {
    const { email, questionId, answer } = req.body;
    
    let questions = await readJsonFile('questions.json');
    let users = await readJsonFile('users.json');
    
    const question = questions.find(q => q.id === questionId);
    const user = users.find(u => u.email === email);
    
    if (question && user && !user.answeredQuestions.includes(questionId)) {
        question.attempts++;
        const decayFactor = 1 - (question.attempts * 0.1);
        const pointsEarned = Math.round(question.points * decayFactor);
        
        if (answer === question.correctAnswer) {
            user.score += pointsEarned;
            user.answeredQuestions.push(questionId);
            await writeJsonFile('users.json', users);
            res.json({ correct: true, pointsEarned, newScore: user.score });
        } else {
            res.json({ correct: false, pointsEarned: 0, newScore: user.score });
        }
        
        await writeJsonFile('questions.json', questions);
    } else {
        res.status(400).json({ error: 'Invalid question, user, or already answered' });
    }
});

app.get('/api/leaderboard', async (req, res) => {
    const users = await readJsonFile('users.json');
    const leaderboard = users
        .sort((a, b) => b.score - a.score)
        .map(({ name, score }) => ({ name, score }));
    res.json(leaderboard);
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});