from fastapi import FastAPI
from pydantic import BaseModel, Field
import joblib
import numpy as np
from fastapi.middleware.cors import CORSMiddleware

# Load model and scaler
model = joblib.load("incidence_of_malaria_per_1000_people.pkl")
scaler = joblib.load("feature_scaler.pkl")

# Define app
app = FastAPI(
    title="Malaria Incidence Prediction API",
    description="Predicts incidence of malaria per 1,000 people using key features",
    version="1.0.0"
)

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Input Schema
class MalariaFeatures(BaseModel):
    malaria_cases_reported: float = Field(..., ge=0, description="Number of malaria cases reported")
    bed_net_use_pct: float = Field(..., ge=0, le=100, description="Bed net usage (%)")
    fever_antimalarial_pct: float = Field(..., ge=0, le=100, description="Children with fever receiving antimalarials (%)")
    ipt_pregnancy_pct: float = Field(..., ge=0, le=100, description="IPT of malaria in pregnancy (%)")
    urban_pop_growth_pct: float = Field(..., ge=-10, le=15, description="Urban population growth (%)")
    rural_pop_growth_pct: float = Field(..., ge=-10, le=15, description="Rural population growth (%)")
    urban_pop_pct: float = Field(..., ge=0, le=100, description="Urban population (% of total)")
    basic_sanitation_pct: float = Field(..., ge=0, le=100, description="Basic sanitation access (%)")
    drinking_water_urban_pct: float = Field(..., ge=0, le=100, description="Urban drinking water access (%)")

@app.post("/predict")
def predict_malaria(data: MalariaFeatures):
    # Extract and transform input
    features = np.array([[ 
        data.malaria_cases_reported,
        data.bed_net_use_pct,
        data.fever_antimalarial_pct,
        data.ipt_pregnancy_pct,
        data.urban_pop_growth_pct,
        data.rural_pop_growth_pct,
        data.urban_pop_pct,
        data.basic_sanitation_pct,
        data.drinking_water_urban_pct
    ]])
    
    # Scale input
    scaled_features = scaler.transform(features)
    
    # Predict
    prediction = model.predict(scaled_features)[0]
    
    return {
        "predicted_incidence_per_1000": round(prediction, 2)
    }
