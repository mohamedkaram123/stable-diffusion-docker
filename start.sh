#!/bin/bash

# تأكد أن التوكن موجود في متغير البيئة HF_TOKEN
if [ -z "$HF_TOKEN" ]; then
  echo "❌ HF_TOKEN is not set. Aborting."
  exit 1
fi

echo "🔐 Using Hugging Face token..."

mkdir -p /root/.huggingface
echo "token=$HF_TOKEN" > /root/.huggingface/token

# تحميل SDXL Base
wget --header "Authorization: Bearer $HF_TOKEN" \
  -O /stable-diffusion-webui/models/Stable-diffusion/sd_xl_base_1.0.safetensors \
  https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors

# تحميل IP-Adapter SDXL
wget --header "Authorization: Bearer $HF_TOKEN" \
  -O /stable-diffusion-webui/models/IP-Adapter/ip-adapter-plus_sdxl.safetensors \
  https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sdxl.safetensors

wget --header "Authorization: Bearer $HF_TOKEN" \
  -O /stable-diffusion-webui/models/IP-Adapter/ip-adapter-plus_sdxl.yaml \
  https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sdxl.yaml

# تشغيل WebUI
cd /stable-diffusion-webui
python3 launch.py --listen $CLI_ARGS
