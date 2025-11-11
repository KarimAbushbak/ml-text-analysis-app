"""
Entry point for Hugging Face Spaces deployment
This is a copy of main.py optimized for HF Spaces
"""
from main import app

# Hugging Face Spaces will run this automatically
if __name__ == "__main__":
    import uvicorn
    import os
    
    port = int(os.getenv("PORT", 7860))  # HF Spaces uses port 7860
    uvicorn.run(app, host="0.0.0.0", port=port)

