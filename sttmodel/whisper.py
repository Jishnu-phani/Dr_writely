import openai
from transformers import AutoTokenizer, AutoModelForTokenClassification, pipeline

# openai.api_key = ""

# Open the audio file
with open("/Users/Jay/Documents/Hackathons/Inferentia/reduced.mp3", "rb") as audio_file:
    # Transcribe the audio file using the Whisper model
    response = openai.audio.transcriptions.create(
        model="whisper-1",
        file=audio_file
    )

# Extract and print only the transcription text
transcription_text = response.text


model_path = "/Users/Jay/Documents/Hackathons/Inferentia/model"
tokenizer = AutoTokenizer.from_pretrained(model_path)
model = AutoModelForTokenClassification.from_pretrained(model_path)
pipe = pipeline("ner", model=model, tokenizer=tokenizer, aggregation_strategy="simple")
out_ = pipe(transcription_text)
temp = ''
meds_arr = []
for i in out_:
    if i['entity_group'] == 'Medication' and i['word'][0] == '#':
        if len(meds_arr) == 0:
            continue
        meds_arr.pop(-1)
        num = len(temp)
        fin = temp + i['word'][num:]
        meds_arr.append(fin)
        
    elif i['entity_group'] == 'Medication':
        if i['score'] > 0.8:
            meds_arr.append(i['word'])
    temp = i['word']
    
print(meds_arr)