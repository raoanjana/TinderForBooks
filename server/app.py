#!/usr/bin/env python
from flask import Flask
from flask_restful import Resource, Api, reqparse

app = Flask(__name__)
api = Api(app)

class Recommender(Resource):
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('asin1', type=str, required=True)
        parser.add_argument('asin2', type=str, required=False)
        parser.add_argument('asin3', type=str, required=False)
        parser.add_argument('asin4', type=str, required=False)
        parser.add_argument('asin5', type=str, required=False)
        args = parser.parse_args()
        return {
            'asin1' : args['asin1'],
        }


@app.route('/', methods=['GET'])
def index():
    return 'You are being greeted by pageturner!'

api.add_resource(Recommender, '/recommend', endpoint='recommend')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)