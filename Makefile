postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine
create-db:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank
drop-db:
	docker exec -it postgres12 dropdb simple_bank
migrate-up:
	migrate -path db/migration -database "postgres://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose up
migrate-down:
	migrate -path db/migration -database "postgres://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose down
sqlc:
	sqlc generate
test-db:
	go test --timeout 30s github.com/thanhnguyenchi/simplebank/db/sqlc -run ^TestMain$
test:
	go test -v -cover ./...

.PHONY: create-db postgres drop-db migrate-up sqlc test-db