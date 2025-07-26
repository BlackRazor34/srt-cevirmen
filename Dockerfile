# Dockerfile

# --- Stage 1: Builder ---
# Belirli bir sürüm kullanarak tekrarlanabilir build'ler sağlar.
FROM python:3.9-slim AS builder

# Güvenlik için non-root kullanıcı oluşturma
# Streamlit ve diğer araçlar bu kullanıcının home dizininden çalışacak
RUN useradd -ms /bin/bash streamlit
ENV HOME=/home/streamlit
# Kullanıcının local paketlerini PATH'e ekle
ENV PATH=$HOME/.local/bin:$PATH

WORKDIR /app

# Sadece gereksinimler dosyasını kopyala. Bu satır değişmediği sürece
# alttaki 'pip install' adımı Docker tarafından önbellekten (cache) okunur.
# --chown ile dosya sahipliğini yeni kullanıcıya ver.
COPY --chown=streamlit:streamlit requirements.txt .

# Gereksinimleri non-root kullanıcı olarak yükle. Bu, sistem dosyalarını kirletmez.
RUN su streamlit -c "pip install --no-cache-dir --user -r requirements.txt"

# --- Stage 2: Final Image ---
# Builder aşamasından daha temiz bir final imajı oluştur
FROM python:3.9-slim

# Bir önceki aşamada oluşturulan non-root kullanıcıyı tekrar oluştur
RUN useradd -ms /bin/bash streamlit
ENV HOME=/home/streamlit
ENV PATH=$HOME/.local/bin:$PATH

WORKDIR /app

# Builder aşamasından yüklenmiş paketleri ve uygulama kodunu kopyala
COPY --from=builder $HOME/.local /home/streamlit/.local
COPY --chown=streamlit:streamlit . .

# Container'ın sahibi olarak streamlit kullanıcısını ayarla
USER streamlit

# Streamlit'in çalışacağı portu belirt (belgelendirme amaçlı)
EXPOSE 8501

# Uygulamayı çalıştır. Ayarlar .streamlit/config.toml dosyasından okunacak.
CMD ["streamlit", "run", "streamlit_app.py"]