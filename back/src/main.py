import pyodbc
import datetime
import configparser
import fastapi
import uvicorn
import json
import fastapi.middleware.cors
import pydantic


app = fastapi.FastAPI()

origins = [
    "http://localhost:8000",
    "http://localhost:8080"
]

app.add_middleware(
    fastapi.middleware.cors.CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


cfg = configparser.ConfigParser()
setting = cfg.read('settings.cfg')


class CreateAtomDto(pydantic.BaseModel):
  title : str
  description : str

class AtomDto:
  def __init__(self, id : int, title : str, description : str, createDate : datetime.datetime):
    self.id = id
    self.title = title
    self.description = description
    self.createDate = createDate

  def toDict(self) -> dict:
    return {
      "id" : self.id,
      "title" : self.title,
      "description" : self.description,
      "createDate" : self.createDate
    }


class AtomRepository:
  con : pyodbc.Connection
  def __init__(self, cfg : configparser.ConfigParser):
    self.drivers = [item for item in pyodbc.drivers()]
    self.driver = self.drivers[-1]

    self.server : str = cfg.get('Database', 'server') 
    self.database : str = cfg.get('Database', 'database')
    self.uid : str = cfg.get('Database', 'uid')
    self.pwd : str = cfg.get('Database', 'pwd')
    self.con_string : str = f'DRIVER={self.driver};SERVER={self.server};DATABASE={self.database};UID={self.uid};PWD={self.pwd};TrustServerCertificate=yes;'
    self.table_atoms : str = 'todo.Atoms' 
    print(self.con_string)
    try:
        self.con = pyodbc.connect(self.con_string)
    except ex:
        print("didnt connect to database :( ")
  def query(self, query : str):
    try:
      self.con.execute(query)
    except:
      if self.con is not None:
        self.con.rollback()
      else:
        print("connection must not be None")
      raise

  def commit(self):
    try:
      self.con.commit()
    except:
      if self.con is None:
        print("connection must not be None")
      else:
        raise

  def add_atom(self, atom : CreateAtomDto):
    try:
      if atom is None:
        raise Exception("atom must not be None")
      query : str = f"insert into {self.table_atoms} " + "(title, description, createDate) " + f"values ('{atom.title}', '{atom.description}', '{datetime.date.today()}')"
      print(f"query: {query}")
      self.con.execute(query)
    except:
      if self.con is not None:
        self.con.rollback()
      else:
        print("connection must not be None")
      raise
  
  def get_atoms(self):
    query : str = f"select * from {self.table_atoms}"  
    rows = self.con.execute(query).fetchall()
    atoms : list[AtomDto] = []
    for i in rows:
      atoms.append(AtomDto(i.id, i.title, i.description, i.createDate).toDict())
    return atoms

  def __del__(self):
    print('Destructor called')
    if self.con is not None:
      self.con.close()
    else:
      print("connection must not be null here")


@app.get("/health")
async def main():
  return {"message": "alive"}



@app.get("/atoms")
async def get_all():
  db = AtomRepository(cfg)
  print("/atoms web request, get, db= ", db)
  try:
    atoms = db.get_atoms() 
    db.commit()
    return atoms
  except Exception as ex:
    return ex.args
  finally:
    del db
  
@app.post("/atom")
async def create(atom : CreateAtomDto): 
  db = AtomRepository(cfg)
  try:
    db.add_atom(atom)
    db.commit()
    return fastapi.status.HTTP_201_CREATED
  except Exception as ex:
    return ex.args
  finally:
    del db

  return atom

@app.put("update")
async def user():
  pass

if __name__ == '__main__':
  uvicorn.run("main:app", host=cfg.get('Hosting', 'host'), port=int(cfg.get('Hosting', 'port')), reload=True)
