# Stage 1: Build the Frontend
FROM node:16-alpine as frontend
WORKDIR /app/frontend
RUN apk update && apk add git
# Clone the GitHub repository with your static web files
RUN git clone https://github.com/DissectMalware/yaradbg-frontend ./
RUN npx browserslist@latest --update-db
RUN npm install
RUN npm run build

# Stage 2: Build the Backend
FROM mcr.microsoft.com/azure-functions/python:3.0-python3.9 as backend
WORKDIR /app/backend
RUN apt-get update
RUN apt install git -y
RUN git clone https://github.com/DissectMalware/yaradbg-backend ./
RUN pip install --no-cache-dir -r requirements.txt
	
# Stage 3: Create the Final Image
FROM mcr.microsoft.com/azure-functions/python:3.0-python3.9
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \ 
	CORS_ALLOWED_ORIGINS="[\"*\"]" \
	CONTAINER_NAME="yaradbg.dev" \
	ASPNETCORE_URLS=http://+:7071 
	
WORKDIR /app
COPY --from=frontend /app/frontend/dist /app/frontend
COPY --from=backend /app/backend /home/site/wwwroot

RUN pip install -r /home/site/wwwroot/requirements.txt

# Expose port 80 for the static web app
EXPOSE 80

# Expose port 7071 for Azure Functions
EXPOSE 7071

# Command to start both frontend and backend
CMD ["sh", "-c", "/azure-functions-host/Microsoft.Azure.WebJobs.Script.WebHost & cd /app/frontend && python -m http.server 80"]

