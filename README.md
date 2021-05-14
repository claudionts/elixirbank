# Elixirbank - Api Banking Challenge

### - Setup
```
Fill in connection data with Postgres at: /config/dev.exs and /config/test.exs

$ mix deps.get       Install dependencies
$ mix ecto.create    Create database
$ mix ecto.migrate   Create migrations
$ mix test           Run tests
$ mix test --cover   Test coverage
$ mix phx.server     Run api server
```
### - Docker
```
$ docker-compose up
```


### - Create User
```
 curl -X POST \
 http://localhost:4000/api/users \
 -H 'Content-Type: application/json' \
 -H 'cache-control: no-cache' \
 -d '{
    "name": "Teste",
    "nickname": "teste",
    "password": "123456",
    "email": "teste@gmail.com"
 }'
```
#### response
```
{
    "message": "User created",
    "user": {
        "account": {
            "balance": "1000.00",
            "id": "8a8792ff-f93e-425e-bfdb-ae1687f75776"
        },
        "id": "256e2447-148e-4980-9fe6-2cd1c2f6a198",
        "name": "Teste",
        "nickname": "teste"
    }
}
```


### SignIn
```
 curl -X POST \
 http://localhost:4000/api/signin \
 -H 'Content-Type: application/json' \
 -H 'cache-control: no-cache' \
 -d '{
    "email": "teste@gmail.com",
    "password": "123456"
}'
```
#### response
```
{
    "data": {
        "user": {
            "name": "Teste",
            "nickname": "teste",
            "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJlbGl4aXJiYW5rX3dlYiIsImV4cCI6MTYyMzQzNzcyMSwiaWF0IjoxNjIxMDE4NTIxLCJpc3MiOiJlbGl4aXJiYW5rX3dlYiIsImp0aSI6IjUyNmZjMjAwLWVlYjMtNDQwMC1hNTIxLWU3MDJmZmYxN2MxMSIsIm5iZiI6MTYyMTAxODUyMCwic3ViIjoiYmRhYzk1NjAtMjQxYy00MmU2LWI2NzItN2QzZmU2Yzg3ZTA2IiwidHlwIjoiYWNjZXNzIn0.ayqUlRdjfRBBZMcOsIan6s90bCkCZhTNACcRzlf5edIVNwJSj2F_khAW2S6t7lEoE6j7G1KHfXR60NH8GJsJ1g"
        }
    },
    "message": "User Authenticated"
}
```


### Deposit Account
```
 curl -X POST \
 http://localhost:4000/api/deposit \
 -H 'Content-Type: application/json' \
 -H 'Authorization: Bearer JWT-TOKEN-HERE' \
 -H 'cache-control: no-cache' \
 -d '{
    "value": "700.00"
}'
```
#### response
```
{
    "account": {
        "balance": "1700.00",
        "id": "b33a7500-6d32-4292-89e6-1226c645515b"
    },
    "message": "Ballance changed successfully"
}
```


#### Withdraw Account
```
 curl -X POST \
 http://localhost:4000/api/withdraw \
 -H 'Content-Type: application/json' \
 -H 'Authorization: Bearer JWT-TOKEN-HERE' \
 -H 'cache-control: no-cache' \
 -d '{
    "value": "700.00"
}'
```
#### response
```
{
    "account": {
        "balance": "1000.00",
        "id": "b33a7500-6d32-4292-89e6-1226c645515b"
    },
    "message": "Ballance changed successfully"
}
```


### Transaction Account
```
 curl -X POST \
 http://localhost:4000/api/transaction \
 -H 'Content-Type: application/json' \
 -H 'Authorization: Bearer JWT-TOKEN-HERE' \
 -H 'cache-control: no-cache' \
 -d '{
    "to": "52cd0527-b950-4a10-9bcb-ab6d891c44b4",
    "value": "140.00"
}'
```
#### response
```
{
    "message": "Transaction done successfully",
    "transaction": {
        "from_account": {
            "balance": "760.00",
            "id": "b33a7500-6d32-4292-89e6-1226c645515b"
        },
        "to_account": {
            "balance": "4520.00",
            "id": "552be221-1991-4130-a4e0-e6d5d6a11942"
        }
    }
}
```



### Transaction Account
```
 curl -X GET \
 http://localhost:4000/api/extract \
 -H 'Content-Type: application/json' \
 -H 'Authorization: Bearer JWT-TOKEN-HERE' \
 -H 'cache-control: no-cache'
```
#### response
```
{
    "message": "Account statement",
    "extract": {
        "user": {
            "account": {
                "balance": "760.00",
                "id": "b33a7500-6d32-4292-89e6-1226c645515b"
            },
            "email": "claudionts@gmail.com",
            "id": "b33a7500-6d32-4292-89e6-1226c645515b",
            "name": "Claudio Neto",
            "nickname": "claudionts",
            "operation": [
               {
                    "id": "b9d74dfb-b5c1-42eb-be4d-a2e89f5cfd5f",
                    "from_id": "b33a7500-6d32-4292-89e6-1226c645515b",
                    "to_id": "52cd0527-b950-4a10-9bcb-ab6d891c44b4",
                    "type": "transaction",
                    "value": "140.00"
                },
               {
                    "id": "b9d74dfb-b5c1-42eb-be4d-a2e89f5cfd5f",
                    "from_id": "b33a7500-6d32-4292-89e6-1226c645515b",
                    "to_id": "",
                    "type": "withdraw",
                    "value": "700.00"
                },
                
               {
                    "id": "b9d74dfb-b5c1-42eb-be4d-a2e89f5cfd5f",
                    "from_id": "b33a7500-6d32-4292-89e6-1226c645515b",
                    "to_id": "",
                    "type": "deposit",
                    "value": "700.00"
                }
            ]
        }
    },
```
