let currentUser = null;
let questions = [];
let currentQuestionIndex = 0;

const loginForm = document.getElementById('loginForm');
if (loginForm) {
    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const name = document.getElementById('name').value;
        const email = document.getElementById('email').value;
        
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            alert('Please enter a valid email address.');
            return;
        }
        
        const response = await fetch('/api/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name, email })
        });
        
        currentUser = await response.json();
        localStorage.setItem('user', JSON.stringify(currentUser));
        window.location.href = 'quiz.html';
    });
}

if (window.location.pathname.includes('quiz.html')) {
    currentUser = JSON.parse(localStorage.getItem('user'));
    if (!currentUser) {
        window.location.href = 'index.html';
    } else {
        initQuiz();
    }
}

async function initQuiz() {
    await fetchQuestions();
    loadQuestion();
    updateLeaderboard();
}

async function fetchQuestions() {
    const response = await fetch('/api/questions');
    questions = await response.json();
}

function loadQuestion() {
    const questionText = document.getElementById('questionText');
    const optionsContainer = document.getElementById('optionsContainer');
    const submitButton = document.getElementById('submitAnswer');
    
    if (currentQuestionIndex < questions.length) {
        const question = questions[currentQuestionIndex];
        questionText.textContent = question.text;
        
        optionsContainer.innerHTML = '';
        question.options.forEach((option, index) => {
            const button = document.createElement('button');
            button.textContent = option;
            button.onclick = () => selectOption(index);
            optionsContainer.appendChild(button);
        updateNavigationButtons();    
        });
        
        submitButton.style.display = 'block';
        submitButton.onclick = submitAnswer;
    } else {
        questionText.textContent = "Quiz completed!";
        optionsContainer.innerHTML = '';
        submitButton.style.display = 'none';
    }
}

let selectedOptionIndex = -1;

function selectOption(index) {
    const optionButtons = document.querySelectorAll('#optionsContainer button');
    optionButtons.forEach((button, i) => {
        if (i === index) {
            button.classList.add('selected');
        } else {
            button.classList.remove('selected');
        }
    });
    selectedOptionIndex = index;
}

async function submitAnswer() {
    if (selectedOptionIndex === -1) {
        alert('Please select an answer before submitting.');
        return;
    }

    const question = questions[currentQuestionIndex];
    const selectedAnswer = question.options[selectedOptionIndex];
    
    const response = await fetch('/api/submit-answer', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            email: currentUser.email,
            questionId: question.id,
            answer: selectedAnswer
        })
    });
    
    const result = await response.json();
    
    if (result.error) {
        alert(result.error);
        return;
    }
    
    if (result.correct) {
        currentUser.score = result.newScore;
        document.getElementById('score').textContent = currentUser.score;
    }
    
    currentQuestionIndex++;
    selectedOptionIndex = -1;
    loadQuestion();
    updateLeaderboard();
    
}

async function updateLeaderboard() {
    const response = await fetch('/api/leaderboard');
    const leaderboard = await response.json();
    
    const leaderboardList = document.getElementById('leaderboardList');
    leaderboardList.innerHTML = '';
    leaderboard.forEach((user, index) => {
        const li = document.createElement('li');
        li.textContent = `${index + 1}. ${user.name}: ${user.score}`;
        leaderboardList.appendChild(li);
    });
}
function updateNavigationButtons() {
    const prevButton = document.getElementById('prevQuestion');
    const nextButton = document.getElementById('nextQuestion');

    prevButton.disabled = currentQuestionIndex === 0;
    nextButton.disabled = currentQuestionIndex === questions.length - 1;
}

function goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        loadQuestion();
    }
}

function goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        loadQuestion();
    }
}

// Add event listeners for navigation buttons
document.getElementById('prevQuestion').addEventListener('click', goToPreviousQuestion);
document.getElementById('nextQuestion').addEventListener('click', goToNextQuestion);

// Modify the submitAnswer function
