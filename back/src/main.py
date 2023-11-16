import flask

app = flask.Flask(__name__)

atoms = [
  {
    'id': 1,
    'title' : 'first atom',
    'description' : 'first ever atoms description',
    'crtDate' : 1,
    'dueDate' : 2
  } 
]

@app.route("/")
def index():
  return "hello world"

@app.route("/atoms")
def get_atoms():
  return flask.jsonify(atoms)

@app.route("/atom")
def get_atom():
  for i in atoms:
    if i.get('id') == 1:
      return flask.jsonify(atoms) 
  return "could not found"