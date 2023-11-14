from flask import Flask, request, jsonify
import re
from joblib import load

app = Flask(__name__)

def allg_ing(st,pred):
    allg = ['milk', 'nut', 'gluten', 'fish']
    milk_allg = ['milk', 'buttermilk', 'butter', 'cheese', 'yoghurt', 'cheese', 'whipping cream']
    nut_allg = ['nut', 'walnut', 'almond', 'hazelnut', 'pecan', 'cashew', 'pistachio', 'raisins']
    gluten_allg = ['wheat', 'rye', 'barley', 'malt', 'yeast', 'starch', 'corn starch']
    fish_allg = ['carp', 'bass', 'salmon', 'trout', 'tuna', 'cod']

    # st = "sugar,whipping cream,powdered sugar,semisweet chocolate,large egg yolks,corn starch,slivered almonds,whole milk"
    ingredients = st.split(",")
    # pred = np.array([[1, 1, 1, 0]])

    allergen_mapping = {
        0: milk_allg,
        1: nut_allg,
        2: gluten_allg,
        3: fish_allg
    }

    filtered_ingredients_list = []

    for i, is_present in enumerate(pred[0]):
        if is_present:
            allergy_list = allergen_mapping.get(i, [])
            filtered_ingredients = [ingredient for ingredient in ingredients if any(allg_ingredient in ingredient for allg_ingredient in allergy_list)]
            filtered_ingredients_list.extend(filtered_ingredients)

            # print(f"Allergen: {allg[i]}")
            # print(f"Ingredients: {filtered_ingredients}")
            # print("\n")

    # print("All Filtered Ingredients:")
    # print(filtered_ingredients_list)
    return filtered_ingredients_list



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
    # model = load("lib/safebite_API/edi_pipeline.joblib")
    model = load("safe_bite/lib/safebite_API/edi_pipeline.joblib")
    allergies = model.predict([ingredients_string])
    d['predicted_allergies'] = allergies[0].tolist()
    res=allg_ing(ingredients_string,allergies)
    d['ingredients']=res

    return jsonify(d)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)