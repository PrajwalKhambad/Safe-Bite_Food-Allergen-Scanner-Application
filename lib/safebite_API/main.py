from flask import Flask, request, jsonify
import re
from joblib import load

app = Flask(__name__)

def extract_ingredient(text):
    # Define a regular expression pattern to match ingredients without brackets
    # pattern = r'\b([^()]+)\b'
    pattern = r'\b[^\[\]()]+\b'
    # Use re.sub to remove anything inside brackets, including the brackets
    # text_no_brackets = re.sub(r'\([^)]*\)', '', text)
    text_no_round_brackets = re.sub(r'\([^)]*\)', '', text)
    text_no_brackets = re.sub(r'\[[^\]]*\]', '', text_no_round_brackets)
    # Use re.findall to find all the ingredient matches in the modified text
    ingredients = re.findall(pattern, text_no_brackets)

    return ingredients

@app.route('/api', methods=['GET','POST'])
def pred_allergies():
    d = {}
    text = str(request.args['query'])
    extracted_ingredients = extract_ingredient(text)
    ingredients_string = ', '.join(extracted_ingredients)
    d['extracted_ingredients'] = ingredients_string
    model = load("lib/safebite_API/edi_pipeline.joblib")
    allergies = model.predict([ingredients_string])
    d['predicted_allergies'] = allergies[0].tolist()

    return jsonify(d)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)