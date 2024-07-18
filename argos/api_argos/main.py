from fastapi import FastAPI, Query  # type: ignore
from googletrans import Translator, LANGUAGES  # type: ignore
import uvicorn  # type: ignore

app = FastAPI()
translator = Translator()


@app.get("/")
def root():
    return {
        "endpoints": [
            {
                "path": "/translate",
                "method": "GET",
                "description": "Translate text to the specified language",
                "parameters": [
                    {
                        "name": "text",
                        "type": "str",
                        "description": "Text to be translated",
                        "required": True,
                    },
                    {
                        "name": "lang",
                        "type": "str",
                        "description": "Target language code",
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


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8089)
