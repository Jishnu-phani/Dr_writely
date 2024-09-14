import firebase_admin
from firebase_admin import db,storage,credentials
import datetime
import sys
sys.path.insert(1, 'Dr-Writely-Git/Dr_writely/pdf_convert')

from pdf import pdf_conv


cred = credentials.Certificate('Dr_writely/Firebase/credentials.json')
firebase_admin.initialize_app(
    cred,
    {'databaseURL' : 'https://dr-writely-default-rtdb.asia-southeast1.firebasedatabase.app/','storageBucket': 'dr-writely.appspot.com'}
)

bucket = storage.bucket()

now = datetime.datetime.now()
s = [now.year, now.month, now.day, now.hour, now.minute]
strx = ""
for i in s:
    strx += str(i) if i>9 else '0'+str(i)

def create_doctor_account(doctor,patient,medicines,text):
    date = str(datetime.date.today())
    ref1 = db.reference(f'/User/Doctor/{doctor}/{patient}')
    ref2 = db.reference(f"/User/Patient/{patient}")
    ch1 = ref1.child(strx)
    ch2 = ref2.child(strx)
    ch2.set({'medication': medicines,'date':date})
    ch1.set({'date': date,'transcript':text})

def upload_pdf_to_bucket(patient,id,path):
    file_name = id
    blob = bucket.blob(f'{file_name}/{patient}.pdf')
    blob.upload_from_filename(path)

sample_text = '''Symptoms: Flaring of acne, two small folliculitis lesions  
Medical condition/Inference: Acne, folliculitis
Medication: Amoxilin 500-MGBID, Tazorac Cream 0.1
Medical Procedures: Photo facials at Healing Waters
Additional info: The patient is married, works as a secretary, has hay fever, eczema, sinus issues.

Summary: The patient has been experiencing a flare-up of acne and folliculitis lesions on her chest, stomach, neck, and back for the past two months. She has been using Amoxilin and Tazorac Cream, but has been out'''

pdf_conv(sample_text)
upload_pdf_to_bucket('tejas',strx,'Dr_writely/Firebase/gg.pdf')

lines = sample_text.split('\n')[-1]

create_doctor_account('jayant','tejas',['dolo'],lines)

