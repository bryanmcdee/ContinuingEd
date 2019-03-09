class RandomQuote extends HTMLElement {
    constructor() {
        super();

        this._quotes = [
            "I have not failed. I've just found 10,000 ways that won't work.",
            "Tell me and I forget. Teach me and I remember. Involve me and I learn.",
            "The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart",
            "When you reach the end of your rope, tie a knot in it and hang on.",
            "Keep your face always toward the sunshine - and shadows will fall behind you."
        ];
        this._$quote = null;
        this._interval = null;
    }
    connectedCallback(){
        this.innerHTML = `
        <style>
        .rq-container {
            width: 500px;
            margin: auto;
            border: dotted 1px #999;
            padding: 20px;
        }
        .rq-container h1 {
            font-size: 20px;
            margin: 0;
        }        
        </style>
        <div class="rq-container">
            <h1>Random Quote:</h1>
            <p>"<span id="quote"></span>"</p>
        </div>        
        `;   
        this._$quote = this.querySelector("#quote");     
        this._setQuoteInterval(this.getAttribute("interval"));
        this._renderQuote();
    }
    _renderQuote() {
        if (this._$quote !== null) {
            this._$quote.innerHTML = this._quotes[Math.floor(Math.random() * this._quotes.length)];
        }
    }
    _setQuoteInterval(value) {
        if (this._interval !== null) {
            clearInterval(this._interval);
        }
        if (value > 0) {
            this._interval = setInterval(() => this._renderQuote(), value);
        }
    }
    static get observedAttributes() {
        return ["interval"];
    }
    attributeChangedCallback(name, oldValue, newValue) {
        this._setQuoteInterval(newValue);
    }
    disconnectedCallback() {
        clearInterval(this._interval);
    }
}

window.customElements.define("random-quote", RandomQuote);