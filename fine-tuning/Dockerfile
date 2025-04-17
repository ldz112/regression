# 使用NVIDIA CUDA 12.1基础镜像
FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

# 设置工作目录
WORKDIR /app

# 设置环境变量, 不希望出现这些交互式操作
ENV DEBIAN_FRONTEND=nointeractive \
   PYTHONUNBUFFERED=1 \
   CUDA_HOME=/usr/local/cuda \
   PATH=$PATH:/usr/local/cuda/bin


# Install dependencies
RUN apt-get update && apt-get install -y \
        python3.11 \
        python3.11-dev \
        python3-pip \
        git \
        wget \
        && rm -rf /var/lib/apt/lists/*
        
# 创建python虚拟环境软链接
RUN ln -sf /usr/bin/python3.12 /usr/bin/python3 && \
   ln -sf /usr/bin/python3.12 /usr/bin/python
   
# 升级pip
RUN python3 -m pip install --no-cache-dir --upgrade pip

# 安装pytorch和CUDA相关依赖
RUN pip3 install --no-cache-dir \
   torch==2.5.1 \
   torchvision==0.20.1 \
   torchaudio==2.5.1 \
   --index-url https://download.pytorch.org/whl/cu121
   


# 安装项目依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


#dl相关包
RUN pip3 install --no-cache-dir \
    accelerate==1.3.0 \
    transformers==4.48.3 \
    peft==0.14.0 \
    bitsandbytes==0.45.2 \
    deepspeed==0.16.3 \
    xformers==0.0.28.post3 \
    vllm==0.7.2
    
# 创建必要的目录
RUN mkdir -p /app/data /app/output_model /app/logs

# 设置缓存目录
ENV HF_HOME=/app/.cache/huggingface

COPY . /app/

#设置权限
RUN chmod +x /app/start_sft_single_gpu.sh /app/start_sft_multi_gpu.sh

#设置启动命令
CMD ["/bin/bash"]