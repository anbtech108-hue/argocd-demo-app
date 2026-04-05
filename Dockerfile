FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

<<<<<<< HEAD
CMD ["python", "app1.py"]
=======
CMD ["python", "-u", "app1.py"]
>>>>>>> 1d32fce (Coorecte and add the Flask update)
