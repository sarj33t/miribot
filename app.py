from chatterbot import ChatBot
from chatterbot.trainers import ChatterBotCorpusTrainer
from flask import Flask, request, jsonify

app = Flask(__name__)

chatbot = ChatBot('Miri')

trainer = ChatterBotCorpusTrainer(chatbot)

trainer.train(
    "chatterbot.corpus.english"
)

@app.route('/')
def home():
    return "Hello, Flask with ChatterBot!"

# Chatbot response route
@app.route('/chat', methods=['POST'])
def chat():
    user_input = request.json.get("message")
    bot_response = chatbot.get_response(user_input)
    return jsonify(response=str(bot_response))

if __name__ == '__main__':
    app.run(debug=True, port=8000, host="0.0.0.0")