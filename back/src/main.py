import flask
import flask_cors
import flask_swagger_ui

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

atoms = [
  {
    'id': 1,
    'title' : 'first atom',
    'description' : 'first ever atoms description',
    'crtDate' : 1,
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
