import random
import threading
from fastapi import FastAPI, Query, UploadFile, File, HTTPException  # type: ignore
from googletrans import Translator  # type: ignore
import uvicorn  # type: ignore
from datetime import datetime, timedelta
import automatic_speech_recognition as asr
from pydub import AudioSegment
from io import BytesIO

rooms = {}
ROOM_EXPIRATION_TIME = timedelta(hours=2)

app = FastAPI()
translator = Translator()

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


pipeline = asr.load("deepspeech2", lang="en")


@app.get("/")
def root():
    return {
        "endpoints": [
            {
                "path": "/translate/{lang}?text={text_to_translate}",
                "method": "GET",
                "description": "Translate text to the specified language",
                "parameters": [
                    {
                        "name": "lang",
                        "type": "str",
                        "description": "Target language code",
                        "required": True,
                    },
                    {
                        "name": "text",
                        "type": "str",
                        "description": "Text to be translated",
                        "required": True,
                    },
                ],
            },
            {
                "path": "/languages",
                "method": "GET",
                "description": "Get a list of supported languages",
            },
        ]
    }


@app.post("/translate_audio/{lang}")
async def translate_audio(lang: str, file: UploadFile = File(...)):
    try:
        # Verifica el tipo de archivo
        if not file.filename.endswith(".wav"):
            raise HTTPException(status_code=400, detail="File must be a WAV audio file")

        # Convertir archivo de audio a texto
        audio = BytesIO(await file.read())
        sample = asr.utils.read_audio(audio)
        sentences = pipeline.predict([sample])
        text = sentences[0]  # Asumiendo que obtenemos una lista de transcripciones

        # Realizar la traducción
        short_lang = "es" if len(lang) != 2 else lang
        if short_lang not in LANGUAGES:
            raise HTTPException(
                status_code=400, detail=f"Language '{short_lang}' is not supported"
            )

        translation = translator.translate(text, dest=short_lang)
        return {"original_text": text, "translated_text": translation.text}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")


@app.get("/translate/{lang}")
def translate_text(lang: str, text: str = Query(..., description="Text to translate")):
    try:
        # Default
        short_lang = "es"

        if len(lang) == 2:
            short_lang = lang
        else:
            short_lang = lang.split("-")[0]

        if short_lang not in LANGUAGES:
            return {"error": f"Language '{short_lang}' is not supported"}

        translation = translator.translate(text, dest=short_lang)
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


@app.get("/room/generate")
def generate_room():
    room_id = generate_unique_room_code()
    rooms[room_id] = datetime.now()  # Guardar el timestamp actual
    return {"room_id": room_id, "message": "Room generated successfully"}


@app.get("/room/clear")
def clear_rooms():
    rooms.clear()
    return {"message": "Rooms cleared successfully"}


@app.get("/room/{room_id}")
def check_room_exists(room_id: str):
    if room_id in rooms:
        return {"room_id": room_id, "message": "Room exists"}
    else:
        return {"room_id": room_id, "message": "Room does not exist"}


#############
# CLEAN UP PERDIODICALLY
def remove_expired_rooms():
    now = datetime.now()
    expired_rooms = [
        room_id
        for room_id, timestamp in rooms.items()
        if now - timestamp > ROOM_EXPIRATION_TIME
    ]
    for room_id in expired_rooms:
        del rooms[room_id]


def periodic_cleanup():
    remove_expired_rooms()
    threading.Timer(3600, periodic_cleanup).start()


#############

if __name__ == "__main__":
    periodic_cleanup()
    uvicorn.run(app, host="0.0.0.0", port=8089)
