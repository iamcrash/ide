clean_cont:
	docker rm -f $(shell docker container ls -a -q) 

clean_img:
	docker rmi $(shell docker images -a -q)

clean_ps:
	docker rm -f $(shell docker ps -a -q) 

clean:
	@echo "Cleaning..."
	docker-compose down 
	docker rm -f $(shell docker ps -a -q) 

remove_untagged_images:
	docker rmi $(docker images | grep "^<none>" | awk "{print $3}")

build:
	@echo "Building..."
	rsync -a ~/dotfiles .
	docker-compose build

build_no_cache:
	@echo "Building..."
	rsync -a ~/dotfiles .
	docker-compose build --no-cache


prune:
	@echo "Prune..."
	# Remove images, containers, volumes, and networks
	docker system prune -a

remove_images:
	@echo "Removing all images..."
	docker rmi $(shell docker images -a -q)

start:
	@echo "Starting..."
	rsync -a ~/dotfiles .
	docker-compose run --name my-editor editor

up:
	# Use --build for updat
	docker-compose up --build
