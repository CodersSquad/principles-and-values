CONTAINER_ENGINE := docker

ifeq (, $(shell which docker))
    CONTAINER_ENGINE := podman
    ifeq (, $(shell which podman))
        $(error "Neither docker nor podman found. Please install one.")
    endif
endif

all: public

html :
	$(CONTAINER_ENGINE) run --rm -v ${PWD}:/mnt -e MARP_USER="$(id -u):$(id -g)" \
	-e LANG=${LANG} -p 8080:8080 -p 37717:37717 marpteam/marp-cli -I /mnt --html --allow-local-files

pdf :
	$(CONTAINER_ENGINE) run --rm -v ${PWD}:/mnt -e MARP_USER="$(id -u):$(id -g)" \
	-e LANG=${LANG} -p 8080:8080 -p 37717:37717 marpteam/marp-cli -I /mnt --pdf --allow-local-files

serve :
	$(CONTAINER_ENGINE) run --rm --init -v ${PWD}:/home/marp/app/ -e LANG=${LANG} \
	-e MARP_USER="$(id -u):$(id -g)" -p 8080:8080 marpteam/marp-cli -s .

public: clean html
	mkdir -p public/
	mkdir -p src
	mv -f *.html public/
	cp -rf images/ public/
	cp -rf src/ public/

clean:
	rm -rf *.html public
