The objective of this project is to build a Docker image for running YaraDbg, encompassing both the [YaraDbg Backend](https://github.com/DissectMalware/yaradbg-backend) and [YaraDbg Frontend](https://github.com/DissectMalware/yaradbg-frontend) projects within a container.

# 1.a. Pull YaraDbg image from Docket Hub
```
docker pull dissectmalware/yaradbg:latest
```
# 1.b. Build Docker Image
You can alternatively build a YaraDbg image from YaraDbg frontend and backend github project. 
First, clone https://github.com/DissectMalware/yaradbg-container project, and then run the following commands.
```
docker build -t dissectmalware/yaradbg .
```

# 2. Run YaraDbg Container using Docker
First create a new container based on Yaradbg image you created in Build Docker Image section
```
docker run -p 7071:7071 -p 8081:80 --runtime=runc -d dissectmalware/yaradbg:latest
```
Then browse http://localhost:8081

YaraDbg frontend connects to its backend on http://localhost:7071




