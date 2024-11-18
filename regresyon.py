import firebase_admin
from firebase_admin import credentials, firestore
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
import numpy as np
from datetime import datetime

cred = credentials.Certificate("D:/projects/pythonkey/privatekey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()
users_ref = db.collection("harcamabilgisi")

docs = users_ref.stream()
liste = []
for doc in docs:
    liste.append(doc.to_dict())

df = pd.DataFrame(liste)


df['tarih'] = pd.to_datetime(df['tarih'], format='%d/%m/%Y')


df['year'] = df['tarih'].dt.year
df['month'] = df['tarih'].dt.month


df = df[['year', 'month', 'isim', 'fiyat']]
# one-hot encoding
df = pd.get_dummies(df, columns=['isim'])


expense_types = [col for col in df.columns if col.startswith('isim_')]
predictions = {}
mses = {}

for expense_type in expense_types:
    
    temp_df = df[['year', 'month', expense_type, 'fiyat']]
    temp_df = temp_df[temp_df[expense_type] == 1]
    
    
    monthly_expenses = temp_df.groupby(['year', 'month']).sum().reset_index()

    if not monthly_expenses.empty:
       
        X = monthly_expenses[['year', 'month']]
        y = monthly_expenses['fiyat']

      #normalizasyon
        scaler = StandardScaler()
        X_scaled = scaler.fit_transform(X)

        # Regresyon modeli
        model = LinearRegression()
        X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.01, random_state=5)
        model.fit(X_train, y_train)

        y_pred = model.predict(X_test)
        mse = mean_squared_error(y_test, y_pred)
        mses[expense_type] = mse

        
        year = 2026
        month = 1
        sample_data = {'year': year, 'month': month}
        sample_df = pd.DataFrame([sample_data])
        sample_df_scaled = scaler.transform(sample_df)
        prediction = model.predict(sample_df_scaled)[0]
        rounded_prediction = round(prediction)
        predictions[expense_type.replace('isim_', '')] = rounded_prediction

        print(f"{expense_type.replace('isim_', '')} için 2026 yılının 1. ayındaki tahmin edilen harcama: {rounded_prediction} TL")
        print(f"{expense_type.replace('isim_','')} modeli için MSE değeri: {mse}")

print(df.describe())


''' result_ref = db.collection("tahmin_sonuclari")

for expense_type, prediction in predictions.items():
    
    data = {
        'harcama_turu': expense_type,
        'tahmin': prediction,
        'mse': mses['isim_' + expense_type],
        'tarih': datetime.now()
    }
    result_ref.add(data)

print("Tahmin sonuçları Firestore'a başarıyla kaydedildi.")
'''
