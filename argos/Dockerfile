FROM python:3.11-bullseye

WORKDIR /argos

COPY ./api_argos/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8089

# Flac to convert wav to flac
RUN apt-get update && \
    apt-get install -y flac && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ruta actual copiar a la ruta de destino
COPY . .

CMD [ "python", "./api_argos/main.py" ]
# Esto es apra que la API se quede siempre activa, en caso de no utilizar ninguna dependencia de SERVER
#CMD [ "sh", "-c", "python ./main.py & tail -f /dev/null" ] 

