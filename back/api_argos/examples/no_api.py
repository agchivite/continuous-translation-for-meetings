import pathlib
from argostranslate.package import install_from_path

package_path = pathlib.Path("../ArgosTranslate/translate-en_vi-1_9.argosmodel")

install_from_path(package_path)

import argostranslate.translate

from_code = "en"
to_code = "vi"

translated_text = argostranslate.translate.translate(
    """text_to_translate""",
    from_code,
    to_code,
)

print(translated_text)
