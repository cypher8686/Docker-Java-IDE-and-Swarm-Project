# Project: Develop docker container using docker compose for application development using Java stack
Student: Vikas Singh
Docker Hub ID: vikasingh86

----------------------------------
PART 1: MONOLITHIC IMAGE (Guidelines 1-5)
----------------------------------
1. Files Included:
   - Dockerfile
   - start-services.sh

2. Docker Hub Link:
   - https://hub.docker.com/r/vikasingh86/my-dev-image

3. How to Build and Run:
   - Build Command: docker build -t my-dev-image .
   - Run Command: docker run -d -p 5901:5901 -p 8080:8080 --name my-dev-container my-dev-image

4. How to Test:
   - Connect VNC Viewer to: localhost:5901 (Password: vncpass)
   - Open Eclipse: docker exec -d -e DISPLAY=:1 my-dev-container /opt/eclipse/eclipse
   - Test Web App: http://localhost:8080/my-test-app/

----------------------------------
PART 2: DOCKER SWARM (Guideline 6)
----------------------------------
1. How to Set Up Cluster (master1, master2, master3):
   - docker run -d --privileged --name master1 docker:dind
   - docker run -d --privileged --name master2 docker:dind
   - docker run -d --privileged --name master3 docker:dind

2. How to Initialize Swarm:
   - docker exec master1 docker swarm init
   - (Get token) docker exec master1 docker swarm join-token manager
   - (Join nodes) docker exec master2 <token-command>
   - (Join nodes) docker exec master3 <token-command>

3. How to Deploy and Scale:
   - Deploy: docker exec master1 docker service create --name my-web-service --replicas 2 -p 8080:80 nginx
   - Scale: docker exec master1 docker service scale my-web-service=5
