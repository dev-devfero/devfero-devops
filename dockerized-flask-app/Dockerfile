# Use official Python image
FROM python:3.10-slim

# Set work directory
WORKDIR /app

# Copy dependencies first
COPY app/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY app/ .

# Expose Flask port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
