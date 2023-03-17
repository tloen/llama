FROM nvcr.io/nvidia/pytorch:23.01-py3
LABEL org.opencontainers.image.authors="soulteary@gmail.com"
WORKDIR /app

COPY app/requirements.txt ./
COPY app/setup.py ./

RUN python -m pip install --upgrade pip
# use latest commit as stable version
RUN git clone https://github.com/tloen/llama-int8.git && \
    cd llama-int8 && git checkout be08e5b466e486b72ecf6364b1a0463887204775 && cd .. && \
    mv llama-int8/* . && rm -rf llama-int8 && \
    pip install wheel && \
    python setup.py bdist_wheel && \
    pip install -r requirements.txt && \
    pip install -e . && \
    pip install gradio

COPY webui.py ./webui.py

CMD ["python", "webui.py"]