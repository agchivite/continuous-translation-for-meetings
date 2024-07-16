from fastapi import FastAPI, Query  # type: ignore
from googletrans import Translator  # type: ignore

app = FastAPI()
translator = Translator()


@app.get("/")
def root():
    return {
        "endpoints": [
            {
                "path": "/translate",
                "method": "GET",
                "description": "Translate text from English to Vietnamese",
                "parameters": [
                    {
                        "name": "text",
                        "type": "str",
                        "description": "Text to be translated",
                        "required": True,
                    }
                ],
            }
        ]
    }


@app.get("/translate")
def translate_text(text: str = Query(..., description="Text to translate")):
    target_lang = "vi"
    try:
        translation = translator.translate(text, dest=target_lang)
        return {"translated_text": translation.text}
    except Exception as e:
        return {"error": f"Translation error: {str(e)}"}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8089)  # type: ignore
