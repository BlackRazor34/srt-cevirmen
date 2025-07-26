# Dockerfile

# Stage 1: Install dependencies
FROM python:3.9-slim AS builder

RUN useradd -ms /bin/bash streamlit
ENV HOME=/home/streamlit
ENV PATH=$HOME/.local/bin:$PATH

WORKDIR /app

COPY --chown=streamlit:streamlit requirements.txt .

RUN su streamlit -c "pip install --no-cache-dir --user -r requirements.txt"

# Stage 2: Create the final image
FROM python:3.9-slim

RUN useradd -ms /bin/bash streamlit
ENV HOME=/home/streamlit
ENV PATH=$HOME/.local/bin:$PATH

WORKDIR /app

COPY --from=builder $HOME/.local /home/streamlit/.local
COPY --chown=streamlit:streamlit . .

USER streamlit

EXPOSE 8501

CMD ["streamlit", "run", "streamlit_app.py"]