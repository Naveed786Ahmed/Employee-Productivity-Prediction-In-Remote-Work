import pandas as pd
import numpy as np
from flask import Flask, request, jsonify
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
import pickle

# Load and train the model (only run once when the API starts)
df = pd.read_csv('employee_productivity_prediction_in_remote_work.csv')

# Feature Engineering
df['Adjusted Task Completion'] = df['Task Completion Rate'] * df['Task Complexity']

# Feature Selection
X = df[['Work Hours (Weekly)', 'Adjusted Task Completion', 
        'Communication Frequency (Email)', 'Communication Frequency (Meetings)', 
        'Break Duration (Hours)']]
y = df['Productivity Score']

# Train the model
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model = LinearRegression()
model.fit(X_train, y_train)

# Save the model
with open('productivity_model.pkl', 'wb') as f:
    pickle.dump(model, f)

# Initialize Flask app
app = Flask(__name__)

# Load the model
with open('productivity_model.pkl', 'rb') as f:
    model = pickle.load(f)

# Define an API endpoint
@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    input_data = pd.DataFrame([data])

    # Calculate Adjusted Task Completion
    input_data['Adjusted Task Completion'] = input_data['Task Completion Rate'] * input_data['Task Complexity']

    # Select model features
    input_data = input_data[['Work Hours (Weekly)', 'Adjusted Task Completion', 
                             'Communication Frequency (Email)', 'Communication Frequency (Meetings)', 
                             'Break Duration (Hours)']]

    # Make prediction
    prediction = model.predict(input_data)

    # Return prediction as JSON
    return jsonify({"Productivity Score Prediction": prediction[0]})

if __name__ == '__main__':
    app.run(debug=True)
