import flask
import flask_cors
import flask_swagger_ui
import pyodbc
import datetime

class CreateAtomDto:
  def __init__(self, title : str, description : str):
    self.title = title
    self.description = description

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
  def __init__(self):
    self.drivers = [item for item in pyodbc.drivers()]
    self.driver = self.drivers[-1]
    self.server : str = 'localhost'
    self.database : str = 'projects'
    self.uid : str = 'SA'
    self.pwd : str = 'P@ssw0rd'
    self.con_string : str = f'DRIVER={self.driver};SERVER={self.server};DATABASE={self.database};UID={self.uid};PWD={self.pwd};TrustServerCertificate=yes;'
    self.table_atoms : str = 'todo.Atoms' 
    self.con = pyodbc.connect(self.con_string)

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

  def AddAtom(self, atom : CreateAtomDto):
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
  
  def GetAtoms(self):
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



app = flask.Flask(__name__)

cors = flask_cors.CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


SWAGGER_URL="/swagger"
API_URL="/static/swagger.json"

swagger_ui_blueprint = flask_swagger_ui.get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={
        'app_name': 'Access API'
    }
)
app.register_blueprint(swagger_ui_blueprint, url_prefix=SWAGGER_URL)


@app.route("/atom", methods=["POST"])
def create_atom():
  if flask.request.method == "POST":
    rq = flask.request.get_json()
    title = rq['title']
    description = rq['description']

  db = AtomRepository()
  try:
    atom = CreateAtomDto(title, description)
    db.AddAtom(atom)
    db.commit()
  except ex:
    #how should this work??
    return ex
  finally:
    del db

@app.route("/atoms", methods=["GET"])
def get_atoms():
  db = AtomRepository()
  try:
    atoms = flask.jsonify(db.GetAtoms())
    return atoms
  finally:
    del db
