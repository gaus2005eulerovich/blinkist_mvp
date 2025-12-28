from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List
import motor.motor_asyncio
import os

app = FastAPI()

# --- 1. Подключение к Базе ---
# Берем URL из переменных окружения (которые мы задали в docker-compose)
# Если переменной нет (локальный запуск), используем localhost
MONGO_URL = os.getenv("MONGO_URL", "mongodb://localhost:27017/blinkist_clone")

client = motor.motor_asyncio.AsyncIOMotorClient(MONGO_URL)
db = client.get_database() 
books_collection = db.get_collection("books")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class Book(BaseModel):
    id: int
    title: str
    author: str
    image_url: str
    audio_url: str
    summary: str

# --- 2. Начальные данные (Seeding) ---

INITIAL_BOOKS = [
    {
        "id": 1,
        "title": "Atomic Habits",
        "author": "James Clear",
        "image_url": "https://images-na.ssl-images-amazon.com/images/I/91bYsX41DVL.jpg",
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        "summary": "An Easy & Proven Way to Build Good Habits & Break Bad Ones..."
    },
    {
        "id": 2,
        "title": "Rich Dad Poor Dad",
        "author": "Robert Kiyosaki",
        "image_url": "https://m.media-amazon.com/images/I/81bsw6fnUiL._AC_UF1000,1000_QL80_.jpg",
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        "summary": "What the Rich Teach Their Kids About Money That the Poor and Middle Class Do Not!..."
    }
]

@app.on_event("startup")
async def startup_db_client():
    # Если в базе 0 книг -> добавляем наши тестовые
    if await books_collection.count_documents({}) == 0:
        await books_collection.insert_many(INITIAL_BOOKS)
        print("Initialized database with mock data")

# --- 3. Роуты (Async!) ---

@app.get("/books", response_model=List[Book])
async def get_books():
    # Ищем все книги, to_list нужен для асинхронности
    # {"_id": 0} означает "не возвращай внутренний id монги", у нас есть свой id
    books = await books_collection.find({}, {"_id": 0}).to_list(length=100)
    return books 

@app.get("/books/{book_id}", response_model=Book)
async def get_book(book_id: int):
    book = await books_collection.find_one({"id": book_id}, {"_id": 0})
    if book:
        return book

    raise HTTPException(status_code=404, detail="Book not found")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)



