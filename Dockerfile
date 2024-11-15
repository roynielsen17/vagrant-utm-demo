# Stage 1: Build stage
FROM python:3.9 AS build-stage

# Install system dependencies for mysqlclient and other needed libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    default-libmysqlclient-dev \
    build-essential \
    libffi-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy only the requirements.txt file into the container
COPY requirements.txt .

# Install Python dependencies using pip3
RUN pip3 install --no-cache-dir -r requirements.txt

# Stage 2: Final stage (runtime environment)
FROM python:3.9-slim

# Install the runtime dependency for mysqlclient
RUN apt-get update && apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the installed Python dependencies from the build stage
COPY --from=build-stage /usr/local/lib/python3.9 /usr/local/lib/python3.9

# Copy necessary files from the host to the container
COPY app.py models.py run.sh ./

# Copy the migrations folder (ensure it exists locally)
COPY migrations/ /app/migrations/

# Ensure run.sh is executable
RUN chmod +x /app/run.sh

# Set the Flask app environment variable
ENV FLASK_APP=app.py

# Expose the Flask port
EXPOSE 5000

# Set entrypoint to handle migrations via run.sh
ENTRYPOINT ["/app/run.sh"]

# Run the Flask app with CMD
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]