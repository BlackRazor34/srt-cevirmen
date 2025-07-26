FROM python:3.9-slim

WORKDIR /app

# Gerekli dosyaları kopyala
COPY . .

# Gereksinimleri yükle
RUN pip install --no-cache-dir -r requirements.txt

# Streamlit config dosyası oluştur
RUN mkdir -p /app/.streamlit && \
    echo "\
[server]\n\
headless = true\n\
port = 7860\n\
enableCORS = false\n\
\n\
[client]\n\
showErrorDetails = true\n\
" > /app/.streamlit/config.toml

# Ortam değişkenlerini ayarla
ENV XDG_CONFIG_HOME=/app/.streamlit
ENV HOME=/app

CMD ["streamlit", "run", "streamlit_app.py", "--server.port=7860", "--server.address=0.0.0.0"]
