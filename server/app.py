#!/usr/bin/env python
from flask import Flask
from flask_restful import Resource, Api, reqparse
from recommend_engine import get_recommendations_from_asins

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

        asins = args['asin1']
        if args['asin2'] is not None:
            asins += "," + args['asin2']
        if args['asin3'] is not None:
            asins += "," + args['asin3']
        if args['asin4'] is not None:
            asins += "," + args['asin4']
        if args['asin5'] is not None:
            asins += "," + args['asin5']

        return get_recommendations_from_asins(asins)


@app.route('/', methods=['GET'])
def index():
    return 'You are being greeted by pageturner!'

api.add_resource(Recommender, '/recommend', endpoint='recommend')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)