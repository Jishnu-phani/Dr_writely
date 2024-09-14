import string
from fpdf import FPDF
'''
text = 
Symptoms: Flaring of acne, two small folliculitis lesions  
Medical condition/Inference: Acne, folliculitis
Medication: Amoxilin 500-MGBID, Tazorac Cream 0.1
Medical Procedures: Photo facials at Healing Waters
Additional info: The patient is married, works as a secretary, has hay fever, eczema, sinus issues.

Summary: The patient has been experiencing a flare-up of acne and folliculitis lesions on her chest, stomach, neck, and back for the past two months. She has been using Amoxilin and Tazorac Cream, but has been out'''

def pdf_conv(text):
    lines = text.strip().split('\n')
    pdf = FPDF()
    pdf.add_page()

# Set the font for the PDF
    pdf.set_font("Arial", size=12)

    for line in lines:
        if ':' in line:
            head, content = line.split(':', 1)
            pdf.set_font("Arial", 'BU', size=13)
            pdf.cell(0, 8, txt=head + ':', ln=True)
            pdf.set_font("Arial", size=10)

        # Use multi_cell for text wrapping
            pdf.multi_cell(0, 9, txt=content.strip())
        else:
        # Handle lines without a colon
            pdf.multi_cell(0, 9, txt=line.strip())

# Output the PDF to a file
    pdf.output('C:/Users/gteja/Documents/Python/Dr-Writely-Git/Dr_writely/Firebase/gg.pdf')
# pdf.add_page()
# pdf.set_font("Arial",size=15)
# pdf.cell(200, 10, txt = text,
#          ln = 2, align = 'L')

# 