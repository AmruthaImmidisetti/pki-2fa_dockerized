#  PKI + TOTP 2FA Authentication Microservice

A secure, containerized authentication microservice implementing **enterprise-grade security practices** using **Public Key Infrastructure (PKI)** and **Time-based One-Time Password (TOTP)**–based two-factor authentication.

This project demonstrates real-world security concepts such as **RSA encryption**, **digital signatures**, **TOTP verification**, **Docker multi-stage builds**, **persistent volumes**, and **cron jobs** in a production-style setup.

---

##  Objective

To build a production-ready authentication microservice that:

- Securely decrypts an encrypted seed using **RSA 4096-bit OAEP**
- Generates and verifies **TOTP-based 2FA codes**
- Runs inside a **Docker container** with **persistent storage**
- Executes a **cron job every minute** to log 2FA codes
- Proves code ownership using **RSA-PSS digital signatures**

---

## 🚀 Features

-  RSA 4096-bit key-based seed decryption (OAEP + SHA-256)
-  Commit proof generation using RSA-PSS signatures
-  TOTP generation and verification (SHA-1, 30s, 6 digits)
-  Fully containerized using Docker & Docker Compose
-  Persistent storage using Docker volumes
-  Cron job runs every minute (UTC)
-  REST API built with FastAPI
-  Multi-stage Docker build for optimized image size

---

##  Tech Stack

- **Language:** Python 3.11  
- **Framework:** FastAPI  
- **Cryptography:** cryptography (RSA, OAEP, PSS)  
- **TOTP:** pyotp  
- **Containerization:** Docker, Docker Compose  
- **Scheduling:** cron (inside container)  

---

##  Project Structure

- pki-2fa/
- ├── app/
- │ ├── main.py
- │ ├── crypto.py
- │ ├── totp_utils.py
- │ └── scripts/
- │ └── log_2fa_cron.py
- ├── cron/
- │ └── 2fa-cron
- ├── student_private.pem
- ├── student_public.pem
- ├── instructor_public.pem
- ├── Dockerfile
- ├── docker-compose.yml
- ├── requirements.txt
- ├── .gitattributes
- ├── .gitignore
- └── README.md

## 🔌 API Endpoints

### 1️ Decrypt Seed

**POST** `/decrypt-seed`

**Request Body**

{
  "encrypted_seed": "BASE64_STRING"
}

**Success Response (200 OK)**

{
  "status": "ok"
}

**Failure Response (500 Internal Server Error)**

{
  "error": "Decryption failed"
}

---

### 2️ Generate 2FA Code

**GET** `/generate-2fa`

**Success Response (200 OK)**

{
  "code": "123456",
  "valid_for": 30
}

**Failure Response (500 Internal Server Error)**

{
  "error": "Seed not decrypted yet"
}

---

### 3️ Verify 2FA Code

**POST** `/verify-2fa`

**Request Body**

{
  "code": "123456"
}

**Success Response (200 OK)**

{
  "valid": true
}

**Failure Responses**

**400 Bad Request**

{
  "error": "Missing code"
}

**500 Internal Server Error**

{
  "error": "Seed not decrypted yet"
}

##  TOTP Configuration

| Parameter      | Value           |
|---------------|-----------------|
| Algorithm     | SHA-1           |
| Time Period   | 30 seconds      |
| Digits        | 6               |
| Seed Format   | Hex → Base32    |
| Verification  | ±1 time window  |

##  Docker Setup

### Build the Container

Use Docker Compose to build the application image without using cache. This ensures all dependencies and configurations are freshly built.

docker-compose build --no-cache

---

### Run the Service

Start the container in detached mode using Docker Compose.

docker-compose up -d

---

### Service Access

Once the container is running, the API service will be available at:

http://localhost:8080

##  Persistent Storage

| Path                 | Purpose                     |
|----------------------|-----------------------------|
| /data/seed.txt       | Stores decrypted seed       |
| /cron/last_code.txt  | Cron job output             |

The data stored in these paths persists across container restarts using Docker named volumes.

##  Cron Job

- Runs automatically every minute
- Generates the current TOTP (2FA) code
- Logs output using UTC timezone
- Output format:

  YYYY-MM-DD HH:MM:SS - 2FA Code: XXXXXX

- Cron configuration file uses LF (Unix) line endings, enforced using `.gitattributes`

---

##  Commit Proof (Cryptographic Verification)

- The latest Git commit hash is signed using RSA-PSS with SHA-256
- The generated signature is encrypted using the instructor’s public key with RSA-OAEP
- The final encrypted signature is base64-encoded and provided as a single-line string
- This process proves authorship, integrity, and correctness of the submission

---

##  Testing Checklist

- ✔ Decrypt seed endpoint works correctly
- ✔ 2FA codes are generated successfully
- ✔ Verification accepts valid codes and rejects invalid ones
- ✔ Decrypted seed persists after container restart
- ✔ Cron job logs 2FA codes every minute
- ✔ UTC timezone is enforced across API and cron
- ✔ Docker container builds and runs successfully

---

##  Security Notes

- Student RSA keys are intentionally committed as required by the assignment
- These keys are **not** intended for real-world or production use
- Do **not** reuse these keys for any other project or application

---

##  Submission Includes

- GitHub repository URL
- Commit hash
- Encrypted commit signature (base64 encoded)
- Student public key
- Encrypted seed (single-line format)
- Complete Dockerized application

---

##  Outcome

This project delivers a secure authentication microservice that combines cryptography, containerization, automation, and REST API design, closely reflecting real-world production security workflows.
