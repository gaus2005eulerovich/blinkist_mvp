@"
# 📚 Blinkist Clone MVP

An audio-summary mobile application built with **Flutter** and **FastAPI**.
Developed as a test assignment for the Fullstack Developer position at Chatty English.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat&logo=flutter)
![FastAPI](https://img.shields.io/badge/Backend-FastAPI-009688?style=flat&logo=fastapi)

## 🎥 Demo Video
https://github.com/user-attachments/assets/31d71928-cc77-4bc3-b5cf-6985438700b4

*Note: Since the backend is local, this video demonstrates the functionality on a physical Samsung device.*

## ✨ Key Features

* **Audio Playback:** Streaming audio summaries with play/pause/seek controls.
* **Synchronized UI:** Text scrolling works independently of the audio player.
* **Data Layer:** Python FastAPI backend serving JSON content and media.
* **Network Handling:** Custom error states for connectivity issues.

## 🚀 How to Run

### 1. Backend (Python)

```bash
cd backend
python -m venv venv
# Windows: .\venv\Scripts\activate
# Mac/Linux: source venv/bin/activate

pip install fastapi uvicorn pydantic
python main.py
