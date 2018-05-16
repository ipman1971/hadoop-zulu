# Build
```
docker build . -t hadoop-zulu
```

# Run
```
docker run -it --rm -h "hadooptest" -p 8088:8088 -p 50070:50070 -p 50090:50090 hadoop-zulu
```

### Referencia: https://github.com/mjaglan/docker-hadoop-pseudo-distributed-mode
