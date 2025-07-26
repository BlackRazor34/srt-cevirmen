FROM python:3.9-slim

# Uygulama klasörü
WORKDIR /app

# Tüm dosyaları kopyala
COPY . .

# Gerekli Python paketlerini yükle
RUN pip install --no-cache-dir -r requirements.txt

# Yeni bir kullanıcı oluştur ve root dizininden çık
RUN useradd -m myuser
USER myuser

# Streamlit konfigürasyonu bu dizine yazılacak
ENV HOME=/home/myuser
ENV XDG_CONFIG_HOME=/home/myuser/.config

# Portu aç
EXPOSE 7860

# Uygulamayı çalıştır
CMD ["streamlit", "run", "streamlit_app.py", "--server.port=7860", "--server.address=0.0.0.0"]
