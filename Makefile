build:
	docker-compose build

test:
	docker-compose run web 'bundle exec rspec'

dev: build
	docker-compose run web 'ash -l'

clean:
	docker-compose stop && docker-compose rm -f
