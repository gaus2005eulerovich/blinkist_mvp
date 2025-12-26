from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from typing import List
from pydantic import BaseModel
import json

app = FastAPI()

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

# Mock data for MVP
BOOKS_DB = [
    {
        "id": 1,
        "title": "Atomic Habits",
        "author": "James Clear",
        "image_url": "https://images-na.ssl-images-amazon.com/images/I/91bYsX41DVL.jpg",
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", 
        "summary": """
An Easy & Proven Way to Build Good Habits & Break Bad Ones.

Introduction:
The fate of British Cycling changed one day in 2003. The organization, which was the governing body for professional cycling in Great Britain, had recently hired Dave Brailsford as its new performance director. At the time, professional cyclists in Great Britain had endured nearly one hundred years of mediocrity.

The Aggregation of Marginal Gains:
Brailsford said, "The whole principle came from the idea that if you broke down everything you could think of that goes into riding a bike, and then improve it by 1 percent, you will get a significant increase when you put them all together."

1. The Surprising Power of Atomic Habits
It is so easy to overestimate the importance of one defining moment and underestimate the value of making small improvements on a daily basis. Too often, we convince ourselves that massive success requires massive action.

2. How Your Habits Shape Your Identity
Why is it so easy to repeat bad habits and so hard to form good ones? Few things can have a more powerful impact on your life than improving your daily habits.
        """
    },
    {
        "id": 2,
        "title": "Rich Dad Poor Dad",
        "author": "Robert Kiyosaki",
        "image_url": "https://m.media-amazon.com/images/I/81bsw6fnUiL._AC_UF1000,1000_QL80_.jpg",
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        "summary": """
What the Rich Teach Their Kids About Money That the Poor and Middle Class Do Not!

Chapter 1: The Rich Don’t Work for Money
The poor and the middle class work for money. The rich have money work for them.
Most people want to be safe and secure, so passion does not direct them. Fear does.

Chapter 2: Why Teach Financial Literacy?
It’s not how much money you make. It’s how much money you keep.
You must know the difference between an asset and a liability, and buy assets. An asset puts money in your pocket. A liability takes money out of your pocket.
        """
    }
]

@app.get("/books", response_model=List[Book])
async def get_books():
    return JSONResponse(content=BOOKS_DB)

@app.get("/books/{book_id}", response_model=Book)
async def get_book(book_id: int):
    book = next((b for b in BOOKS_DB if b["id"] == book_id), None)
    if book:
        return JSONResponse(content=book)
    return JSONResponse(content={"error": "Book not found"}, status_code=404)

if __name__ == "__main__":
    import uvicorn
    # To run: python main.py
    uvicorn.run(app, host="0.0.0.0", port=8000)


    