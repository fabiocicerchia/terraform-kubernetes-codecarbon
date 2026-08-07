FROM python:3.11-slim

LABEL maintainer="GreenOps Team"
LABEL description="CodeCarbon monitoring container for Kubernetes"

# One layer: every extra `RUN ... install` is another layer to transfer and
# store on every pull. gcc is a build dependency for codecarbon's wheels and is
# removed again in the same layer so it never reaches the published image.
RUN apt-get update && apt-get install -y --no-install-recommends gcc \
    && pip install --no-cache-dir codecarbon \
    && apt-get purge -y --auto-remove gcc \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -u 1000 codecarbon

# Set working directory
WORKDIR /app

# Default command
CMD ["codecarbon", "monitor"]
