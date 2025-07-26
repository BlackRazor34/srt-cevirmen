FROM python:3.10-slim

WORKDIR /app

COPY . .

# .streamlit klasörünü oluştur
RUN mkdir -p /app/.streamlit && \
    chmod -R 755 /app/.streamlit

# Streamlit config dosyasını oluştur
RUN echo "\
[general]\n\
email = \"\"\n\
\n\
[server]\n\
headless = true\n\
enableCORS = false\n\
port = 7860\n\
\n\
[theme]\n\
base = \"light\"\n\
" > /app/.streamlit/config.toml

RUN pip install --no-cache-dir -r requirements.txt

CMD ["streamlit", "run", "streamlit_app.py", "--server.port=7860", "--server.address=0.0.0.0"]
