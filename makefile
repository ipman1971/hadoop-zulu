IMAGE_NAME=ipman1971/hadoop-zulu
CONTAINER_NAME=hadoop-zulu-container

default: build

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -itd --name $(CONTAINER_NAME) -h $(hostname) \
		-p 8088:8088 -p 50070:50070 -p 50090:50090 $(IMAGE_NAME)

attach:
	docker attach $(CONTAINER_NAME)

clean:
	docker rm -vf $(CONTAINER_NAME)

clean-image:
	docker rmi -f $(IMAGE_NAME)
