# ==========================================
# EduMentor-AI Makefile
# Streamlined automation for Development, QA, and CI/CD
# ==========================================

# -------- Variables --------
PYTHON := python3
PIP := pip3
BACKEND_DIR := development/source_code
FRONTEND_DIR := applications/web_frontend
ENV_FILE := .env

# -------- Setup --------
install:
	@echo "Installing backend dependencies..."
	$(PIP) install -r requirements.txt
	@echo "Installing frontend dependencies..."
	cd $(FRONTEND_DIR)/web_interface && npm install

setup:
	@echo "Setting up environment..."
	cp $(ENV_FILE).example $(ENV_FILE)
	make install

# -------- Run --------
run-backend:
	@echo "Starting FastAPI backend..."
	cd $(BACKEND_DIR)/core && $(PYTHON) -m uvicorn main:app --reload

run-frontend:
	@echo "Starting React frontend..."
	cd $(FRONTEND_DIR)/web_interface && npm start

run-all:
	make run-backend & make run-frontend

# -------- Lint & Format --------
lint:
	@echo "Running linters..."
	flake8 $(BACKEND_DIR)
	cd $(FRONTEND_DIR)/web_interface && npm run lint

format:
	@echo "Formatting code..."
	black $(BACKEND_DIR)
	isort $(BACKEND_DIR)

# -------- Testing --------
test:
	@echo "Running backend tests..."
	pytest --maxfail=1 --disable-warnings -q
	@echo "Running frontend tests..."
	cd $(FRONTEND_DIR)/web_interface && npm test

# -------- Build --------
build:
	@echo "Building frontend..."
	cd $(FRONTEND_DIR)/web_interface && npm run build

# -------- Clean --------
clean:
	@echo "Cleaning temporary files..."
	rm -rf __pycache__ .pytest_cache build dist .coverage

# -------- Docker --------
docker-build:
	@echo "Building Docker image..."
	docker build -t edumentor-ai .

docker-run:
	@echo "Running container..."
	docker run -p 8000:8000 edumentor-ai

# -------- Deployment --------
deploy:
	@echo "Deploying application..."
	bash scripts_automation/cicd_automation/deploy.sh

# -------- Help --------
help:
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
