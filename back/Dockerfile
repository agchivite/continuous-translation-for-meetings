FROM python:3.11-bullseye

WORKDIR /argos

COPY ./api_argos/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir uvicorn[standard]

EXPOSE 8089

# Ruta actual copiar a la ruta de destino
COPY . .

CMD [ "python", "./api_argos/main.py" ]
# Esto es apra que la API se quede siempre activa, en caso de no utilizar ninguna dependencia de SERVER
#CMD [ "sh", "-c", "python ./main.py & tail -f /dev/null" ] 

