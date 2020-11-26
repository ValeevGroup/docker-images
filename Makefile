repo = valeevgroup
latest ?= 20.04
ALL = ${repo}/ubuntu\:18.04 ${repo}/ubuntu\:20.04

${repo}/ubuntu\:%: build = docker build --build-arg ubuntuImage=ubuntu:$* -f ubuntu/Dockerfile ubuntu/

${repo}/ubuntu: ${repo}/ubuntu\:${latest}
	docker tag ${repo}/ubuntu:${latest} $@

${repo}/ubuntu\:%:
	${build} -t $@

${repo}/ubuntu\:%.tar:
	mkdir -p ${repo}
	DOCKER_BUILDKIT=1 ${build} -o - > $@

all: ${ALL} ${repo}/ubuntu

all/tar: $(ALL:%=%.tar)

push/latest: ${repo}/ubuntu
	docker push $?
