# Use Miniconda as the base image
FROM continuumio/miniconda3

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install system dependencies for OpenCV, YOLO, etc.
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libgl1-mesa-glx \
    libgl1 \
    libsm6 \
    libxrender1 \
    libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . .

# Create conda environment with Python 3.10 and activate it
RUN conda create -n pest_env python=3.10 -y

# Install Python dependencies in the conda environment
RUN /bin/bash -c "source activate pest_env && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt"

# Activate the environment and run the FastAPI app
CMD ["/bin/bash", "-c", "source activate pest_env && uvicorn main:app --host 0.0.0.0 --port 5000"]
