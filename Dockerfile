FROM python:3.11-slim

LABEL maintainer="GreenOps Team"
LABEL description="CodeCarbon monitoring container for Kubernetes"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install codecarbon
RUN pip install --no-cache-dir codecarbon

# Create a non-root user (though we'll need root for host access)
RUN useradd -m -u 1000 codecarbon

# Set working directory
WORKDIR /app

# Default command
CMD ["codecarbon", "monitor"]
