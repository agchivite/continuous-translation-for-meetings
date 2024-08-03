from fastapi import FastAPI, Query
from pydantic import BaseModel
import pathlib
import argostranslate.package
import argostranslate.translate

app = FastAPI()

package_path = pathlib.Path("../ArgosTranslate/translate-en_vi-1_9.argosmodel")

argostranslate.package.install_from_path(package_path)


class TranslationRequest(BaseModel):
    text: str


@app.post("/translate")
def translate_text(request: TranslationRequest):
    from_code = "en"
    to_code = "vi"

    # Realiza la traducción
    translated_text = argostranslate.translate.translate(
        request.text, from_code, to_code
    )
    return {"translated_text": translated_text}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
