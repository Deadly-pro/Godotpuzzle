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
        user = { name, email, score: 0, answeredQuestions: {} };
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
    
    if (!question || !user) {
        return res.status(400).json({ error: 'Invalid question or user' });
    }

    const isCorrect = answer === question.correctAnswer;
    
    if (!user.answeredQuestions[questionId] || !user.answeredQuestions[questionId].isCorrect) {
        if (isCorrect) {
            const decayFactor = 1 - (question.attempts * 0.1);
            const pointsEarned = Math.round(question.points * decayFactor);
            user.score += pointsEarned;
            question.attempts++;
        }
        
        user.answeredQuestions[questionId] = { answer, isCorrect };
        await writeJsonFile('users.json', users);
        await writeJsonFile('questions.json', questions);
    }

    res.json({ 
        correct: isCorrect, 
        newScore: user.score, 
        message: isCorrect ? 'Correct!' : 'Incorrect. Try again!'
    });
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