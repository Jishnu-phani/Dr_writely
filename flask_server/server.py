from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# Directory to save uploaded files
UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'audio' not in request.files:
        return 'No audio file part', 400

    file = request.files['audio']
    if file.filename == '':
        return 'No selected file', 400

    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)
    print(f"File saved to {file_path}")

    return 'File uploaded successfully', 200

@app.route('/patient', methods=['POST'])
def receive_patient_name():
    # Get the JSON data from the request body
    data = request.get_json()

    # Access the 'patient_name' from the JSON data
    patient_name = data.get('patient_name')

    # Print the patient name for demonstration (you can save it to a database)
    print(f"Received patient name: {patient_name}")

    # Return a response indicating success
    return f'Patient name received: {patient_name}', 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')