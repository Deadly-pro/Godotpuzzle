let currentUser = null;
let questions = [];
let currentQuestionIndex = 0;
let answeredQuestions = {};

const loginForm = document.getElementById('loginForm');
if (loginForm) {
    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const name = document.getElementById('name').value;
        const email = document.getElementById('email').value;
        
        // Email format validation
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
    setupNavigationButtons();
}

async function fetchQuestions() {
    const response = await fetch('/api/questions');
    questions = await response.json();
}

function loadQuestion() {
    const questionText = document.getElementById('questionText');
    const optionsContainer = document.getElementById('optionsContainer');
    const submitButton = document.getElementById('submitAnswer');
    const questionNumberSpan = document.getElementById('questionNumber');
    
    if (currentQuestionIndex < questions.length) {
        const question = questions[currentQuestionIndex];
        questionText.textContent = question.text;
        
        optionsContainer.innerHTML = '';
        question.options.forEach((option, index) => {
            const button = document.createElement('button');
            button.textContent = option;
            button.onclick = () => selectOption(index);
            if (answeredQuestions[question.id] === index) {
                button.classList.add('selected');
            }
            optionsContainer.appendChild(button);
        });
        
        submitButton.style.display = 'block';
        submitButton.onclick = submitAnswer;
        
        questionNumberSpan.textContent = `Question ${currentQuestionIndex + 1} of ${questions.length}`;
    } else {
        questionText.textContent = "Quiz completed!";
        optionsContainer.innerHTML = '';
        submitButton.style.display = 'none';
        questionNumberSpan.textContent = '';
    }
}

function selectOption(index) {
    const optionButtons = document.querySelectorAll('#optionsContainer button');
    optionButtons.forEach((button, i) => {
        if (i === index) {
            button.classList.add('selected');
        } else {
            button.classList.remove('selected');
        }
    });
    answeredQuestions[questions[currentQuestionIndex].id] = index;
}

async function submitAnswer() {
    const question = questions[currentQuestionIndex];
    const selectedOptionIndex = answeredQuestions[question.id];
    
    if (selectedOptionIndex === undefined) {
        alert('Please select an answer before submitting.');
        return;
    }

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
    
    if (result.correct) {
        currentUser.score = result.newScore;
        document.getElementById('score').textContent = currentUser.score;
    }
    
    updateLeaderboard();
}

function setupNavigationButtons() {
    const prevButton = document.getElementById('prevQuestion');
    const nextButton = document.getElementById('nextQuestion');
    
    prevButton.onclick = () => {
        if (currentQuestionIndex > 0) {
            currentQuestionIndex--;
            loadQuestion();
        }
    };
    
    nextButton.onclick = () => {
        if (currentQuestionIndex < questions.length - 1) {
            currentQuestionIndex++;
            loadQuestion();
        }
    };
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
// ... (previous code remains the same)

async function initQuiz() {
    await fetchQuestions();
    createQuestionTabs();
    loadQuestion();
    updateLeaderboard();
    setupNavigationButtons();
}

function createQuestionTabs() {
    const questionTabs = document.getElementById('questionTabs');
    questions.forEach((_, index) => {
        const tab = document.createElement('div');
        tab.className = 'question-tab';
        tab.textContent = index + 1;
        tab.onclick = () => {
            currentQuestionIndex = index;
            loadQuestion();
        };
        questionTabs.appendChild(tab);
    });
}

function loadQuestion() {
    // ... (previous loadQuestion code)

    // Update question tabs
    updateQuestionTabs();
}

function updateQuestionTabs() {
    const tabs = document.querySelectorAll('.question-tab');
    tabs.forEach((tab, index) => {
        tab.classList.remove('current', 'answered');
        if (index === currentQuestionIndex) {
            tab.classList.add('current');
        }
        if (answeredQuestions[questions[index].id] !== undefined) {
            tab.classList.add('answered');
        }
    });
}

function selectOption(index) {
    // ... (previous selectOption code)

    // Update question tabs
    updateQuestionTabs();
}

async function submitAnswer() {
    // ... (previous submitAnswer code)

    // Update question tabs
    updateQuestionTabs();
}

// ... (rest of the code remains the same)
// ... (previous code remains the same)

async function initQuiz() {
    await fetchQuestions();
    loadQuestion();
    updateLeaderboard();
    setupNavigationButtons();
    populateAllQuestionsList();
}

// ... (other functions remain the same)

function loadQuestion() {
    const questionText = document.getElementById('questionText');
    const optionsContainer = document.getElementById('optionsContainer');
    const submitButton = document.getElementById('submitAnswer');
    const questionNumberSpan = document.getElementById('questionNumber');
    
    if (currentQuestionIndex < questions.length) {
        const question = questions[currentQuestionIndex];
        questionText.textContent = question.text;
        
        optionsContainer.innerHTML = '';
        question.options.forEach((option, index) => {
            const button = document.createElement('button');
            button.textContent = option;
            button.onclick = () => selectOption(index);
            if (answeredQuestions[question.id] === index) {
                button.classList.add('selected');
            }
            optionsContainer.appendChild(button);
        });
        
        submitButton.style.display = 'block';
        submitButton.onclick = submitAnswer;
        
        questionNumberSpan.textContent = `Question ${currentQuestionIndex + 1} of ${questions.length}`;
        updateAllQuestionsListStyles();
    } else {
        questionText.textContent = "Quiz completed!";
        optionsContainer.innerHTML = '';
        submitButton.style.display = 'none';
        questionNumberSpan.textContent = '';
    }
}

function populateAllQuestionsList() {
    const allQuestionsList = document.getElementById('allQuestionsList');
    allQuestionsList.innerHTML = '';
    
    questions.forEach((question, index) => {
        const li = document.createElement('li');
        li.textContent = `Q. ${index + 1}`;
        li.onclick = () => {
            currentQuestionIndex = index;
            loadQuestion();
        };
        allQuestionsList.appendChild(li);
    });
}

function updateAllQuestionsListStyles() {
    const allQuestionsItems = document.querySelectorAll('#allQuestionsList li');
    allQuestionsItems.forEach((item, index) => {
        item.classList.remove('current', 'answered');
        if (index === currentQuestionIndex) {
            item.classList.add('current');
        }
        if (answeredQuestions[questions[index].id] !== undefined) {
            item.classList.add('answered');
        }
    });
}

async function submitAnswer() {
    const question = questions[currentQuestionIndex];
    const selectedOptionIndex = answeredQuestions[question.id];
    
    if (selectedOptionIndex === undefined) {
        alert('Please select an answer before submitting.');
        return;
    }

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
    
    if (result.correct) {
        currentUser.score = result.newScore;
        document.getElementById('score').textContent = currentUser.score;
    }
    
    updateLeaderboard();
    updateAllQuestionsListStyles();
}

// ... (rest of the code remains the same)