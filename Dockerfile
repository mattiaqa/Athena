FROM python:3.9-alpine

WORKDIR /src

ENV FLASK_APP="/src/backend/app"
ENV FLASK_RUN_HOST=0.0.0.0
ENV PYTHONDONTWRITEBYTECODE=1

RUN apk add --no-cache gcc musl-dev linux-headers

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

EXPOSE 5000

COPY backend/ .

CMD ["flask", "run"]