NS = shamsin
REPO = jdk17-slim-latex
NAME = latex
VOLUMES = -v $PWD:/data

.PHONY: build shell run start stop stoprm rm

pull:
	docker pull $(NS)/$(REPO)

push:
	docker push $(NS)/$(REPO)

build:
	git pull
	docker build -t $(NS)/$(REPO) .

shell:
	docker run --rm --name $(NAME) -i -t $(VOLUMES) $(NS)/$(REPO) /bin/bash

run:
	docker run --rm --name $(NAME) $(VOLUMES) $(NS)/$(REPO)

start:
	docker run -d --name $(NAME) $(VOLUMES) $(NS)/$(REPO)

stop:
	docker stop $(NAME)

rm:
	docker rm $(NAME)

default: 
	build