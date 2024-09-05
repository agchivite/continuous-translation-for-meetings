import random
import threading
import asyncio
from fastapi import FastAPI, WebSocket, HTTPException, Query, UploadFile, File  # type: ignore
from fastapi.responses import HTMLResponse  # type: ignore
from fastapi.middleware.cors import CORSMiddleware  # type: ignore
from googletrans import Translator  # type: ignore
from datetime import datetime, timedelta
import speech_recognition as sr  # type: ignore
from io import BytesIO
import websockets  # type: ignore
from websockets.exceptions import ConnectionClosedOK  # type: ignore

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://david.clickapps.org",
        "https://pentecost.clickapps.org",
        "http://wewiza.ddns.net",
        "http://192.168.1.132:8085'",
    ],
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP
    allow_headers=["*"],  # All headers
)

translator = Translator()

rooms = {}
ROOM_EXPIRATION_TIME = timedelta(hours=2)
LANGUAGES = {
    "af": "afrikaans",
    "sq": "albanian",
    "am": "amharic",
    "ar": "arabic",
    "hy": "armenian",
    "az": "azerbaijani",
    "eu": "basque",
    "be": "belarusian",
    "bn": "bengali",
    "bs": "bosnian",
    "bg": "bulgarian",
    "ca": "catalan",
    "ceb": "cebuano",
    "ny": "chichewa",
    "zh-cn": "chinese (simplified)",
    "zh-tw": "chinese (traditional)",
    "co": "corsican",
    "hr": "croatian",
    "cs": "czech",
    "da": "danish",
    "nl": "dutch",
    "en": "english",
    "eo": "esperanto",
    "et": "estonian",
    "tl": "filipino",
    "fi": "finnish",
    "fr": "french",
    "fy": "frisian",
    "gl": "galician",
    "ka": "georgian",
    "de": "german",
    "el": "greek",
    "gu": "gujarati",
    "ht": "haitian creole",
    "ha": "hausa",
    "haw": "hawaiian",
    "iw": "hebrew",
    "he": "hebrew",
    "hi": "hindi",
    "hmn": "hmong",
    "hu": "hungarian",
    "is": "icelandic",
    "ig": "igbo",
    "id": "indonesian",
    "ga": "irish",
    "it": "italian",
    "ja": "japanese",
    "jw": "javanese",
    "kn": "kannada",
    "kk": "kazakh",
    "km": "khmer",
    "ko": "korean",
    "ku": "kurdish (kurmanji)",
    "ky": "kyrgyz",
    "lo": "lao",
    "la": "latin",
    "lv": "latvian",
    "lt": "lithuanian",
    "lb": "luxembourgish",
    "mk": "macedonian",
    "mg": "malagasy",
    "ms": "malay",
    "ml": "malayalam",
    "mt": "maltese",
    "mi": "maori",
    "mr": "marathi",
    "mn": "mongolian",
    "my": "myanmar (burmese)",
    "ne": "nepali",
    "no": "norwegian",
    "or": "odia",
    "ps": "pashto",
    "fa": "persian",
    "pl": "polish",
    "pt": "portuguese",
    "pa": "punjabi",
    "ro": "romanian",
    "ru": "russian",
    "sm": "samoan",
    "gd": "scots gaelic",
    "sr": "serbian",
    "st": "sesotho",
    "sn": "shona",
    "sd": "sindhi",
    "si": "sinhala",
    "sk": "slovak",
    "sl": "slovenian",
    "so": "somali",
    "es": "spanish",
    "su": "sundanese",
    "sw": "swahili",
    "sv": "swedish",
    "tg": "tajik",
    "ta": "tamil",
    "te": "telugu",
    "th": "thai",
    "tr": "turkish",
    "uk": "ukrainian",
    "ur": "urdu",
    "ug": "uyghur",
    "uz": "uzbek",
    "vi": "vietnamese",
    "cy": "welsh",
    "xh": "xhosa",
    "yi": "yiddish",
    "yo": "yoruba",
    "zu": "zulu",
}


class ConnectionManager:
    def __init__(self):
        self.active_connections: dict[str, list[WebSocket]] = {}

    async def connect(self, room_id: str, websocket: WebSocket):
        if room_id not in self.active_connections:
            self.active_connections[room_id] = []
        self.active_connections[room_id].append(websocket)
        await websocket.accept()

    def disconnect(self, room_id: str, websocket: WebSocket):
        self.active_connections[room_id].remove(websocket)
        if not self.active_connections[room_id]:
            del self.active_connections[room_id]

    async def broadcast(self, room_id: str, message: str, sender: WebSocket):
        for connection in self.active_connections[room_id]:
            if connection != sender:
                await connection.send_text(message)


manager = ConnectionManager()


@app.websocket("/ws/{room_id}")
async def websocket_endpoint(websocket: WebSocket, room_id: str):
    if room_id not in rooms:
        await websocket.close()
        raise HTTPException(status_code=404, detail="Room not found")
    lang = rooms[room_id]["lang"]
    await manager.connect(room_id, websocket)
    try:
        while True:
            data = await websocket.receive_text()
            translation = translator.translate(data, dest=lang).text
            await manager.broadcast(room_id, translation, websocket)
    except Exception as e:
        await websocket.close()
        manager.disconnect(room_id, websocket)
        print(f"Exception: {e}")


@app.post("/translate_audio/{lang}")
async def translate_audio(lang: str, file: UploadFile = File(...)):
    try:
        if not file.filename.endswith(".wav"):
            raise HTTPException(status_code=400, detail="File must be a WAV audio file")

        audio_data = BytesIO(await file.read())
        recognizer = sr.Recognizer()
        with sr.AudioFile(audio_data) as source:
            audio = recognizer.record(source)

        try:
            text = recognizer.recognize_google(audio)
        except sr.UnknownValueError:
            raise HTTPException(status_code=400, detail="Could not understand audio")
        except sr.RequestError:
            raise HTTPException(
                status_code=500,
                detail="Could not request results from Google Speech Recognition service",
            )

        if lang not in LANGUAGES:
            raise HTTPException(
                status_code=400, detail=f"Language '{lang}' is not supported"
            )

        translation = translator.translate(text, dest=lang)
        return {"original_text": text, "translated_text": translation.text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")


@app.get("/translate/{lang}")
def translate_text(lang: str, text: str = Query(..., description="Text to translate")):
    try:
        translation = translator.translate(text, dest=lang)
        return {"translated_text": translation.text}
    except Exception as e:
        return {"error": f"Translation error: {str(e)}"}


@app.get("/languages")
def get_languages():
    return {"languages": LANGUAGES}


def generate_unique_room_code():
    while True:
        room_code = "".join(random.choices("0123456789", k=5))
        if room_code not in rooms:
            return room_code


@app.get("/room/generate/{lang}")
def generate_room(lang: str):
    room_id = generate_unique_room_code()
    if lang not in LANGUAGES:
        raise HTTPException(
            status_code=400, detail=f"Language '{lang}' is not supported"
        )
    rooms[room_id] = {"timestamp": datetime.now(), "lang": lang}
    return {"room_id": room_id, "message": "Room generated successfully"}


@app.get("/room/clear")
def clear_rooms():
    rooms.clear()
    return {"message": "Rooms cleared successfully"}


@app.get("/room/{room_id}")
def check_room_exists(room_id: str):
    if room_id in rooms:
        return {"room_id": room_id, "exists": True, "message": "Room exists"}
    else:
        return {"room_id": room_id, "exists": False, "message": "Room does not exist"}


def remove_expired_rooms():
    now = datetime.now()
    expired_rooms = [
        room_id
        for room_id, room_data in rooms.items()
        if now - room_data["timestamp"] > ROOM_EXPIRATION_TIME
    ]
    for room_id in expired_rooms:
        del rooms[room_id]


def periodic_cleanup():
    remove_expired_rooms()
    threading.Timer(3600, periodic_cleanup).start()


""" 
async def main():
    async with websockets.serve(websocket_endpoint, "0.0.0.0", 8089):
        await asyncio.Future()


if __name__ == "__main__":
    periodic_cleanup()
    asyncio.run(main())
"""
""" 
if __name__ == "__main__":
    periodic_cleanup()
    uvicorn.run(app, host="0.0.0.0", port=8089)
"""
