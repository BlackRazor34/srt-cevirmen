---
title: İngilizce Altyazı Çevirici
emoji: 🎬
colorFrom: blue
colorTo: green
sdk: docker
app_port: 8501
---

# 🎬 Altyazı Çevirmeni – Streamlit Uygulaması en➡️tr

Bu proje, `.srt` altyazı dosyalarını İngilizce'den Türkçe'ye çeviren bir Streamlit arayüzü sunar.  
Kullanıcılar tarayıcıdan arayüze ulaşıp dosyalarını yükleyebilir ve tek tıklamayla çevrilmiş altyazıyı indirebilirler.

---

## 🚀 Özellikler

- 🧠 Hugging Face modeli (Helsinki-NLP/opus-mt-en-tr) ile yüksek kaliteli çeviri
- 🎛️ Streamlit ile modern web arayüz
- 📂 SRT dosyası yükleme ve çıktı alma
- 📊 Blok sayısı, karakter sayısı, çeviri süresi gibi istatistikler
- 🐳 Docker ile kolay dağıtım

---

## 📦 Kurulum

### Bu repository'yi klonlayın

```bash
git clone [https://github.com/emredevops/srt-cevirmen.git](https://github.com/emredevops/srt-cevirmen.git)
cd srt-cevirmen