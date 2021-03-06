from flask import Flask, render_template, jsonify, request
import json
import os
import stripe


stripe.api_key = "sk_test_51J5Wl7BgcuVnPZy2BJeENnjxMXDB0kZjbzjIWrHIYwDaPSUUpLuK5G6vWA5lonLEj9yVHO12HiIezjJUu9uyjgcL00cK312ZOp"


app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<h1>Hello, World Stripe</h1>"



@app.route('/create-payment-intent', methods=['POST'])
def create_payment():
    try:
        data = json.loads(request.data)
        print(data)
        intent = stripe.PaymentIntent.create(
            amount= 10000,
            currency='usd'
        )
        print(intent)
        return jsonify({
          'clientSecret': intent['client_secret']
        })
    except Exception as e:
        return jsonify(error=str(e)), 403



if  __name__ == "__main__":
    app.run(debug=True , use_reloader = False)
