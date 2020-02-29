build:
	docker-compose build

up:
	TMPDIR=/private$$TMPDIR docker-compose up -d

test: build up
	docker-compose run web 'bundle exec rspec'

dev: build up
	docker-compose run web 'ash -l'

clean:
	docker-compose stop && docker-compose rm -f
