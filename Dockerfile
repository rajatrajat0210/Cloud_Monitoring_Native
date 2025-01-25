FROM python:3.9-bookworm

WORKDIR /app

COPY  requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

EXPOSE 5000

CMD ["python3", "-m", "flask", "run"]
