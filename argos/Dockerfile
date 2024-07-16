FROM python:3.11-bullseye

WORKDIR /argos

# Instalar dependencias del sistema
RUN apt-get update -qq \
    && apt-get -qqq install --no-install-recommends -y pkg-config gcc g++ \
    && apt-get upgrade --assume-yes \
    && apt-get clean \
    && rm -rf /var/lib/apt

COPY ./api_argos/requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8089

COPY . .

CMD [ "python", "./api_argos/main.py" ]