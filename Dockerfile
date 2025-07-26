
# Temel Python imajı
FROM python:3.10-slim

# Çalışma dizinini ayarla
WORKDIR /app

# Gerekli dosyaları kopyala
COPY streamlit_app.py ./
COPY captions_english.srt ./

# Gerekli paketleri yükle
RUN pip install --no-cache-dir \
    streamlit \
    transformers \
    pysrt \
    torch \
    sentencepiece

FROM python:3.9

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

ENV XDG_CONFIG_HOME=/home/user



CMD ["streamlit", "run", "streamlit_app.py", "--server.port=7860", "--server.address=0.0.0.0"]




