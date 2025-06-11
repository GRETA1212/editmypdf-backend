const express = require('express');
const multer = require('multer');
const cors = require('cors');
const { PDFDocument } = require('pdf-lib');
const { OpenAI } = require('openai');

const app = express();
app.use(cors());
app.use(express.json());

const upload = multer({ storage: multer.memoryStorage() });

// IMPORTANT: Replace 'YOUR_API_KEY' with your environment variable for security
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

app.post('/edit', upload.single('file'), async (req, res) => {
  const prompt = req.body.prompt;
  const buffer = req.file.buffer;

  const pdfDoc = await PDFDocument.load(buffer);
  const pages = pdfDoc.getPages();
  let text = ''; // Placeholder for extracted text

  const completion = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: [{ role: 'user', content: `${prompt}\n\n${text}` }],
  });

  const updatedText = completion.choices[0].message.content;
  const updatedPdf = await pdfDoc.save();

  res.setHeader('Content-Type', 'application/pdf');
  res.send(updatedPdf);
});

// Add health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(3001, () => console.log('Server running on http://localhost:3001'));
