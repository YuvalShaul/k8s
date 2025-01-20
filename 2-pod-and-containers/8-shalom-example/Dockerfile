FROM alpine:3.21.2
WORKDIR /app
RUN apk update
RUN apk add --no-cache python3 py3-pip

# Create a python virtual environment, to install python libraries (like flask) in it.
RUN python -m venv /app/venv

# Activate the new virtual environment:
# (doing this with "source /app/venv/bin/activate   will not work for Docker")
# We want to point to the bin directory of the virtual environement, to run things from it.
ENV PATH="/app/venv/bin:$PATH"


COPY ./requirements.txt /app  
# copies from current directory in host to /app in image
RUN pip install -r requirements.txt

COPY  ./shalom-app.py /app
CMD ["python", "shalom-app.py"]
