import openai
from transformers import AutoTokenizer, AutoModelForTokenClassification, pipeline

openai.api_key = "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"

with open(r"C:/Users/gteja/Documents/Python/Dr-Writely-Git/Dr_writely/Firebase/reduced.mp3", "rb") as audio_file:
    response = openai.audio.transcriptions.create(
        model="whisper-1",
        file=audio_file
    )

transcription_text = response.text


model_path = "C:/Users/gteja/Documents/Python/Dr-Writely-Git/Dr_writely/Firebase/model"
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

response = openai.chat.completions.create(
  model="gpt-4o",
  messages=[
    {
      "role": "system",
      "content": "You have been given a specific raw text. Your task is to extract and format relevant information in order (Make sure there is a summary in the end): Symptoms (if nothing then NA), Medical condition/Inference(if nothing then NA), Medication(if nothing then NA), Medical Procedures(if nothing then NA), Additional info(if nothing then NA), Summary (A small 2-3 sentence description from the raw text). Separate the following info by a tab space."
    },
    {
      "role": "user",
      "content": transcription_text
    }
  ],
  temperature=0.5,
  max_tokens=128,
  top_p=1
)

content_output = response.choices[0].message.content
#print(content_output)