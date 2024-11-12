import pandas as pd
import pickle
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, r2_score

# Load the dataset
df = pd.read_csv('employee_productivity_prediction_in_remote_work.csv')

# Display basic information
print("Dataset Preview:")
print(df.head())

# Check column names and data types
print("\nColumn Names and Data Types:")
print(df.dtypes)

# Check for null values
print("\nNull Values in Each Column:")
print(df.isnull().sum())

# Summary statistics
print("\nSummary Statistics:")
print(df.describe())

# Feature Engineering
df['Adjusted Task Completion'] = df['Task Completion Rate'] * df['Task Complexity']

# Feature Selection
X = df[['Work Hours (Weekly)', 'Adjusted Task Completion', 
        'Communication Frequency (Email)', 'Communication Frequency (Meetings)', 
        'Break Duration (Hours)']]
y = df['Productivity Score']

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Load the saved model or train a new one if needed
try:
    with open('productivity_model.pkl', 'rb') as f:
        model = pickle.load(f)
    print("\nLoaded existing model.")
except FileNotFoundError:
    print("\nNo saved model found. Training a new model.")
    model = LinearRegression()
    model.fit(X_train, y_train)
    # Save the trained model
    with open('productivity_model.pkl', 'wb') as f:
        pickle.dump(model, f)

# Make predictions on the test set
y_pred = model.predict(X_test)

# Comparison of actual vs. predicted values
comparison_df = pd.DataFrame({'Actual': y_test, 'Predicted': y_pred})
print("\nComparison of Actual vs. Predicted Productivity Scores:")
print(comparison_df.head(10))  # Show the first 10 comparisons

# Evaluation metrics
mae = mean_absolute_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)
print(f"\nMean Absolute Error: {mae}")
print(f"R-squared: {r2}")
