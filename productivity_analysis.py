import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

# Step 1: Load the dataset
df = pd.read_csv('employee_productivity_prediction_in_remote_work.csv')  

# Step 2: Explore the data
print("First few rows of the dataset:")
print(df.head())
print("\nData summary:")
print(df.info())

# Step 3: Check for missing values
print("\nMissing values in each column:")
print(df.isnull().sum())

# Step 5: Feature Engineering
# Assuming 'Task Completion Rate' and 'Task Complexity' are numeric, and we create adjusted task completion
df['Adjusted Task Completion'] = df['Task Completion Rate'] * df['Task Complexity']

# Step 6: Feature Selection
# Select features and target variable
X = df[['Work Hours (Weekly)', 'Adjusted Task Completion', 
         'Communication Frequency (Email)', 'Communication Frequency (Meetings)', 
         'Break Duration (Hours)']]
y = df['Productivity Score']

# Step 7: Splitting the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Step 8: Train the model
model = LinearRegression()
model.fit(X_train, y_train)

# Step 9: Make predictions
y_pred = model.predict(X_test)

# Step 10: Evaluate the model
# Print predictions alongside actual values
results = pd.DataFrame({'Actual': y_test, 'Predicted': y_pred})
print("\nComparison of Actual and Predicted Values:")
print(results.head())  # Print first few rows for comparison

# Optional: Calculate and print performance metrics
from sklearn.metrics import mean_absolute_error, r2_score

mae = mean_absolute_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print(f"\nMean Absolute Error: {mae:.2f}")
print(f"R² Score: {r2:.2f}")

