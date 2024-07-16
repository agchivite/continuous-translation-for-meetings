from http.client import HTTPException
from fastapi import FastAPI, Query  # type: ignore
import subprocess

app = FastAPI()


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
    command = f'/usr/bin/trans -b :{target_lang} "{text}"'

    try:
        translated_text = subprocess.check_output(
            command, shell=True, text=True
        ).strip()
        return {"translated_text": translated_text}
    except subprocess.CalledProcessError as e:
        raise HTTPException(status_code=500, detail=f"Translation error: {e}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}")


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8089)  # type: ignore
