#JBoss 7.1.1 on Centos 6.5

###1. Usage
Here i'll try and show how this images could be startet and how to communicate with both the Centos OS and the JBoss server.

Start by pulling the git project
```
git clone https://github.com/hoeghh/CentOS66_JBoss711.git
```
This will download the Dockerfile and userfile to your harddrive.
Enter the directory
```
cd CentOS66_JBoss711
```
And now you can to build the container from the Dockerfile:
```
docker build -t jboss7 .
```
Now you have an image and a container. Now start the container by:
```
docker run -d -p 8080:8080 -p 9990:9990 jboss7
```

The -d option will tell docker to run the image in the background.

Once you have build the container and started it you can add a user by running :

```
docker exec -it [container-id] /opt/jboss/jboss-as-7.1.1.Final/bin/add-user.sh
```
You can find the id of the container by running the following command, once the container has started.
```
docker ps
```
Now navigate to [http://localhost:8080](http://localhost:8080)  and see the JBoss 7 welcome page. If you have created an user, you can click the Administration Console link, or click [here](http://localhost:9990).
