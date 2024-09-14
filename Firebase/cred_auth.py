import firebase_admin
from firebase_admin import db,storage,credentials

cred = credentials.Certificate('Dr_writely/Firebase/credentials.json')
firebase_admin.initialize_app(
    cred,
    {'databaseURL' : 'https://dr-writely-default-rtdb.asia-southeast1.firebasedatabase.app/','storageBucket': 'dr-writely.appspot.com'}
)

bucket = storage.bucket()
