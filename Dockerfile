
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

# Uygulamayı başlat
CMD ["streamlit", "run", "streamlit_app.py", "--server.port=8501", "--server.enableCORS=false"]



