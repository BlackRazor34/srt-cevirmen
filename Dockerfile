# Python 3.9 bazlı imaj
FROM python:3.9-slim

# Çalışma dizini
WORKDIR /app

# Gerekli dosyaları kopyala
COPY . .

# Gereksiz cache dosyalarını almadan yükle
RUN pip install --no-cache-dir -r requirements.txt

# Streamlit'in config dosyalarını yazabilmesi için ortam değişkenleri
ENV XDG_CONFIG_HOME=/home/user
ENV HOME=/home/user

# Gerekli portu aç (Hugging Face varsayılanı 7860)
EXPOSE 7860

# Uygulamanın başlangıç komutu
CMD ["streamlit", "run", "streamlit_app.py", "--server.port=7860", "--server.address=0.0.0.0"]





