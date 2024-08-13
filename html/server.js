// server.js
const express = require('express');
const app = express();
const http = require('http').createServer(app);
const io = require('socket.io')(http);
const path = require('path');

app.use(express.static(path.join(__dirname, 'public')));

const questions = [
    { text: "What is the capital of France?", answer: "Paris", points: 100, answerCount: 0 },
    { text: "Who painted the Mona Lisa?", answer: "Leonardo da Vinci", points: 100, answerCount: 0 },
    { text: "What is the largest planet in our solar system?", answer: "Jupiter", points: 100, answerCount: 0 },
    { text: "What is the chemical symbol for gold?", answer: "Au", points: 100, answerCount: 0 },
    { text: "Who wrote 'Romeo and Juliet'?", answer: "William Shakespeare", points: 100, answerCount: 0 }
];

let players = [];
let currentQuestion = 0;

io.on('connection', (socket) => {
    console.log('A user connected');

    socket.on('join game', (playerName) => {
        players.push({ id: socket.id, name: playerName, score: 0 });
        io.emit('update players', players);
        socket.emit('game state', { currentQuestion: questions[currentQuestion], players });
    });

    socket.on('submit answer', (answer) => {
        const player = players.find(p => p.id === socket.id);
        const question = questions[currentQuestion];

        if (answer.toLowerCase() === question.answer.toLowerCase()) {
            player.score += question.points;
            question.answerCount++;
            question.points = Math.max(10, Math.floor(question.points * 0.9)); // Decay factor

            io.to(socket.id).emit('answer result', { correct: true, points: question.points });
        } else {
            io.to(socket.id).emit('answer result', { correct: false });
        }

        io.emit('update players', players);

        if (question.answerCount >= players.length) {
            currentQuestion = (currentQuestion + 1) % questions.length;
            question.answerCount = 0;
            question.points = 100; // Reset points for the next round
            io.emit('new question', questions[currentQuestion]);
        }
    });

    socket.on('disconnect', () => {
        players = players.filter(p => p.id !== socket.id);
        io.emit('update players', players);
    });
});

const PORT = process.env.PORT || 8060;
http.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});