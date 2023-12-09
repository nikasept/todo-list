
# A small todo list app with elm

## Setting up

For setting up you need:
1. pyodbc (odbc drivers and python library)
2. flask (flask_cors and flask_swagger_ui)
3. elm (with Css plugin)
4. also a database

## Database things
As of now, mssql is recomended.

You can configure the connection to the database in the ` back/src/settings.cfg `,
it should look like this:
```
[Database]
server = localhost
database = TodoElm
uid = SA
pwd = password

```
The back-end main.py reads this file.

Backend uses port `1433` for communication.

### Structure of database (tables and stuff)
Inside the database must be an `Atoms` table,
recomended to be under schema `Todo`.

`Todo.Atoms` table column types:

`(id int indentifier(1,1) , title nvarchar(300), description nvarchar(1000), createDate datetime)`

## Running

### Backend 
In the `back/src/` folder, run `flask --app main.py run`.

### Frontend
Frontend uses elm, as of now you must access it via `elm reactor`,
in the `front` folder.

The main page is `main.elm`