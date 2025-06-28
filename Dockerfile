FROM runpod/stable-diffusion:web-ui-10.2.1

USER root

# تثبيت الأدوات المطلوبة
RUN apt update && apt install -y wget unzip git

# إنشاء المجلدات
RUN mkdir -p /stable-diffusion-webui/models/IP-Adapter && \
    mkdir -p /stable-diffusion-webui/models/Stable-diffusion && \
    mkdir -p /stable-diffusion-webui/extensions/sd-webui-controlnet/models

# تحميل ControlNet extension
RUN rm -rf /stable-diffusion-webui/extensions/sd-webui-controlnet && \
    wget -O /tmp/controlnet.zip https://github.com/Mikubill/sd-webui-controlnet/archive/refs/heads/main.zip && \
    unzip /tmp/controlnet.zip -d /tmp && \
    mv /tmp/sd-webui-controlnet-main /stable-diffusion-webui/extensions/sd-webui-controlnet

# نسخ سكربت التشغيل
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENV CLI_ARGS="--port 3000 --api --xformers --enable-insecure-extension-access --skip-torch-cuda-test"

EXPOSE 3000
CMD ["/start.sh"]
