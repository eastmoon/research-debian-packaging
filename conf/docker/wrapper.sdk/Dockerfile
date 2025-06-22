FROM python:slim

# Update tools
RUN apt-get update -y
RUN apt-get install -y \
    tar \
    zip

# Add algorithm script
ADD sha3sum.py .

# Setting Container
ENTRYPOINT ["bash"]
