build:
	docker-compose build

dev: build
	docker-compose run web 'ash -l'

clean:
	docker-compose stop && docker-compose rm -f
