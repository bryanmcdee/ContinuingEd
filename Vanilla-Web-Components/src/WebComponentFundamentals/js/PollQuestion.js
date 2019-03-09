class PollQuestion extends HTMLElement {
    constructor() {
        super();
        this._componentAttachedToDom = false;
        this._pollQuestionsAndAnswers = {
            "question": "Are web components awesome?",
            "answers" : ["Yes of course they are!", "No definitely not."]
        };
        this._selectedAnswer = null;

        this._$question = null;
        this._$answers = null;
    }
    connectedCallback() {
        this._componentAttachedToDom = true;
        this.innerHTML = `
        <style>
            .poll-container {
                background-color: #333;
            }
            .poll-container h3 {
                margin: 0;
                padding: 0 20px;
                color: #FFF;
                line-height: 50px;
            }
            .poll-container ul {
                list-style: none;
                margin: 0;
                padding: 0;
            }
            .poll-container ul li {
                padding: 0 20px;
                line-height: 50px;
                background-color: #E1E1E1;
                border: solid 1px #CCC;
                border-top: none;
                cursor: pointer;
            }
            .poll-container ul li:hover {
                background-color: #CCC;
            }
            .poll-container ul li.selected {
                background-color: #5cb85c;
                color: #FFF;
            }        
        </style>
        <div class="poll-container">
            <h3 id="question"></h3>
            <ul id="answers"></ul>
        </div>
        `;

        this._$question = this.querySelector("#question");
        this._$answers = this.querySelector("#answers");
        this._$answers.addEventListener("click", (event) => {
            this._$answers.querySelectorAll("li").forEach(($li, index) => {
                if ($li === event.target) {
                    this.selectedAnswer = index;
                }
            });
        });
        this._renderPoll();
    }

    _renderPoll() {
        if (this._componentAttachedToDom && this._pollQuestionsAndAnswers !== null) {
            this._$answers.innerHTML = "";
            this._$question.innerHTML = this._pollQuestionsAndAnswers.question;
            this._pollQuestionsAndAnswers.answers.forEach((answer) => {
                const $li = document.createElement("li");
                $li.innerHTML = answer;
                this._$answers.appendChild($li);
            });
        }
    }

    set pollData(data) {
        if (this._pollQuestionsAndAnswers === data) return;
        if (!this._pollDataIsValid(data)) return;
        this._pollQuestionsAndAnswers = data;
        this._renderPoll();
    }

    get pollData() {
        return this._pollQuestionsAndAnswers;
    }

    set selectedAnswer(index) {
        const $answer = this._$answers.querySelector(`li:nth-child(${index + 1})`);
        if ($answer !== null) {
            this._$answers.querySelectorAll("li").forEach(($li) => {
                $li.classList.remove("selected");
            });
            $answer.classList.add("selected");
            this._selectedAnswer = index;
        }
    }

    get selectedAnswer() {
        return this._selectedAnswer;
    }

    _pollDataIsValid(pollData) {
        const containsQuestion = pollData.hasOwnProperty("question");
        const containsAnswer = pollData.hasOwnProperty("answers");
        return containsQuestion && containsAnswer;
    }
}

window.customElements.define("poll-question", PollQuestion);