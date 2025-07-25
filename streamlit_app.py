
import streamlit as st
from transformers import MarianMTModel, MarianTokenizer
import io
import time

# Model yükleyici (cache'li)
@st.cache_resource
def load_model():
    model_name = "Helsinki-NLP/opus-mt-tc-big-en-tr"
    tokenizer = MarianTokenizer.from_pretrained(model_name)
    model = MarianMTModel.from_pretrained(model_name)
    return tokenizer, model

tokenizer, model = load_model()

# Sayfa başlığı
st.title("🎬 İngilizce Altyazı (.srt) Türkçe Çevirici")


uploaded_file = st.file_uploader("Bir .srt dosyası yükleyin", type=["srt"])

def translate_line(text):
    tokens = tokenizer.prepare_seq2seq_batch([text], return_tensors="pt", padding=True)
    translated = model.generate(**tokens)
    return tokenizer.decode(translated[0], skip_special_tokens=True)

if uploaded_file is not None:
    try:
        srt_content = uploaded_file.read().decode("utf-8")
    except UnicodeDecodeError:
        uploaded_file.seek(0)
        try:
            srt_content = uploaded_file.read().decode("cp1254")  # Türkçe Windows
        except UnicodeDecodeError:
            uploaded_file.seek(0)
            srt_content = uploaded_file.read().decode("iso-8859-9")  # Latin-5



    # Alternatif olarak cp1254 de denenebilir

    lines = srt_content.strip().split("\n")

    output_lines = []
    temp_block = []

    # Bloklara ayır
    for line in lines:
        if line.strip() == "":
            if temp_block:
                output_lines.append(temp_block)
                temp_block = []
        else:
            temp_block.append(line)
    if temp_block:
        output_lines.append(temp_block)

    translated_srt = []
    preview_data = []

    start_time = time.time()
    st.info(f"Toplam blok sayısı: {len(output_lines)}")
    with st.spinner("Çeviri yapılıyor..."):
        for idx, block in enumerate(output_lines):
            if len(block) < 3:
                translated_srt.extend(block + [""])
                continue

            translated_block = block[:2]  # numara + zaman
            text_lines = block[2:]
            translated_texts = [translate_line(line) for line in text_lines]
            translated_block.extend(translated_texts)
            translated_srt.extend(translated_block + [""])

            # Önizleme için
            preview_data.append({
                "index": block[0],
                "original": " ".join(text_lines),
                "translated": " ".join(translated_texts)
            })

    end_time = time.time()
    duration = end_time - start_time

    output_str = "\n".join(translated_srt)
    st.success(f"Çeviri tamamlandı ✅ ({duration:.2f} saniye)")

    # İstatistikler
    st.subheader("📊 Çeviri İstatistikleri")
    total_chars = sum(len(item["original"]) for item in preview_data)
    st.markdown(f"- Toplam blok: **{len(preview_data)}**")
    st.markdown(f"- Toplam karakter (girdi): **{total_chars}**")
    st.markdown(f"- Ortalama blok uzunluğu: **{total_chars / len(preview_data):.1f}**")

    # Önizleme
    st.subheader("📝 Önizleme")
    for item in preview_data[:5]:
        st.markdown(f"**⏱️ {item['index']}**")
        st.text(f"EN: {item['original']}")
        st.text(f"TR: {item['translated']}")
        st.markdown("---")

    # Dosya indir
    st.download_button(
        label="📥 Türkçe SRT Dosyasını İndir",
        data=output_str,
        file_name="captions_tr.srt",
        mime="text/plain"
    )
