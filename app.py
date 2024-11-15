import logging
from logging.handlers import RotatingFileHandler
from flask import Flask, request, jsonify
from models import db, Student
import os
from flask_migrate import Migrate
from dotenv import load_dotenv  # For loading environment variables from .env file

# Load environment variables from the .env file
load_dotenv()

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)  # Capture all levels of logs

# Create a file handler for all logs
file_handler = RotatingFileHandler('app.log', maxBytes=10240, backupCount=10)
file_handler.setLevel(logging.DEBUG)

# Create a console handler for WARNING and above
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.WARNING)

# Create a formatter and add it to the handlers
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
file_handler.setFormatter(formatter)
console_handler.setFormatter(formatter)

# Add the handlers to the logger
logger.addHandler(file_handler)
logger.addHandler(console_handler)

app = Flask(__name__)

# Load the single database URL from environment variable
DB_URL = os.getenv('DB_URL')
if not DB_URL:
    logger.critical("No DB_URL set for Flask application.")
    raise ValueError("No DB_URL set for Flask application.")

# Set SQLAlchemy configuration
app.config['SQLALCHEMY_DATABASE_URI'] = DB_URL
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize DB and migration tool
db.init_app(app)
migrate = Migrate(app, db)

logger.info('Application has started.')


# Custom error handler for 404 - Not Found
@app.errorhandler(404)
def resource_not_found(e):
    logger.warning(f"Resource not found: {request.url}")
    return jsonify({'error': 'Resource not found'}), 404


# Custom error handler for 400 - Bad Request
@app.errorhandler(400)
def bad_request(e):
    logger.error(f"Bad request: {request.url} - {request.data}")
    return jsonify({'error': 'Bad request', 'message': str(e)}), 400


# Generic error handler for 500 - Internal Server Error
@app.errorhandler(500)
def internal_server_error(e):
    logger.error(f"Server error: {str(e)}", exc_info=True)
    return jsonify({'error': 'Internal Server Error', 'message': 'An unexpected error occurred'}), 500


# Routes
@app.route('/api/v1/students', methods=['GET'])
def get_students():
    students = Student.query.all()
    logger.info('Fetched all students.')
    return jsonify([{'id': s.id, 'name': s.name, 'age': s.age, 'grade': s.grade} for s in students])


@app.route('/api/v1/students/<int:id>', methods=['GET'])
def get_student(id):
    student = Student.query.get_or_404(id)
    logger.info(f"Fetched student with ID {id}.")
    return jsonify({'id': student.id, 'name': student.name, 'age': student.age, 'grade': student.grade})


@app.route('/api/v1/students', methods=['POST'])
def add_student():
    data = request.get_json()

    # Handle missing fields in the request
    if not all(k in data for k in ('name', 'age', 'grade')):
        logger.warning(f"Bad request - Missing fields in POST data: {data}")
        return bad_request('Missing required fields: name, age, or grade')

    new_student = Student(name=data['name'], age=data['age'], grade=data['grade'])
    db.session.add(new_student)
    db.session.commit()
    logger.info(f"Added new student: {data['name']}.")
    return jsonify({'message': 'Student added successfully!'}), 201


@app.route('/api/v1/students/<int:id>', methods=['PUT'])
def update_student(id):
    student = Student.query.get_or_404(id)
    data = request.get_json()

    if not data:
        logger.warning(f"Bad request - No data in PUT request for student ID {id}")
        return bad_request('Request body cannot be empty')

    student.name = data['name']
    student.age = data['age']
    student.grade = data['grade']
    db.session.commit()
    logger.info(f"Updated student with ID {id}.")
    return jsonify({'message': 'Student updated successfully!'})


@app.route('/api/v1/students/<int:id>', methods=['DELETE'])
def delete_student(id):
    student = Student.query.get_or_404(id)
    db.session.delete(student)
    db.session.commit()
    logger.info(f"Deleted student with ID {id}.")
    return jsonify({'message': 'Student deleted successfully!'})


@app.route('/api/v1/healthcheck', methods=['GET'])
def healthcheck():
    logger.info('Health check endpoint called.')
    return jsonify({'status': 'API is healthy!'})


if __name__ == '__main__':
    logger.info('Starting the Flask application...')
    app.run(debug=True, host='0.0.0.0', port=5000)
