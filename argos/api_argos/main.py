from fastapi import FastAPI, Query  # type: ignore
import pathlib
import argostranslate.package  # type: ignore
import argostranslate.translate  # type: ignore

app = FastAPI()
package_path = pathlib.Path("../api_argos/translate-en_vi-1_9.argosmodel")
argostranslate.package.install_from_path(package_path)


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
                        "required": "True",
                    }
                ],
            }
        ]
    }


@app.get("/translate")
def translate_text(text: str):
    from_code = "en"
    to_code = "vi"

    translated_text = argostranslate.translate.translate(text, from_code, to_code)
    return {"translated_text": translated_text}


if __name__ == "__main__":
    import uvicorn  # type: ignore

    uvicorn.run(app, host="0.0.0.0", port=8089)
