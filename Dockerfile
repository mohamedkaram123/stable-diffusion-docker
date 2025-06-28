FROM runpod/stable-diffusion:web-ui-10.2.1

USER root

ARG HF_TOKEN

# أدوات ضرورية
RUN apt update && apt install -y git wget

# حفظ التوكن الخاص بـ Hugging Face
RUN mkdir -p /root/.huggingface && \
    echo "token=$HF_TOKEN" > /root/.huggingface/token

# تحميل ControlNet (أو استخدام المدمج إن وجد)
RUN rm -rf /stable-diffusion-webui/extensions/sd-webui-controlnet && \
    git clone https://github.com/Mikubill/sd-webui-controlnet.git /stable-diffusion-webui/extensions/sd-webui-controlnet

# مجلدات النماذج
RUN mkdir -p /stable-diffusion-webui/models/IP-Adapter && \
    mkdir -p /stable-diffusion-webui/models/Stable-diffusion && \
    mkdir -p /stable-diffusion-webui/extensions/sd-webui-controlnet/models

# تحميل نموذج SDXL Base
RUN wget --header "Authorization: Bearer $HF_TOKEN" -O /stable-diffusion-webui/models/Stable-diffusion/sd_xl_base_1.0.safetensors \
    https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors

# تحميل نموذج IP-Adapter SDXL
RUN wget --header "Authorization: Bearer $HF_TOKEN" -O /stable-diffusion-webui/models/IP-Adapter/ip-adapter-plus_sdxl.safetensors \
    https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sdxl.safetensors && \
    wget --header "Authorization: Bearer $HF_TOKEN" -O /stable-diffusion-webui/models/IP-Adapter/ip-adapter-plus_sdxl.yaml \
    https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sdxl.yaml

# إعداد API فقط
ENV CLI_ARGS="--port 3000 --api --xformers --enable-insecure-extension-access --skip-torch-cuda-test"

EXPOSE 3000

CMD ["python3", "launch.py", "--listen"]
