# Start with a base container of ubuntu 14.04 when this project is
# built it will download the base ubuntu image and apply all changes
# to that.
FROM ubuntu:14.04

# This simply identifies the maintainer of the container
MAINTAINER jmiller@adops.com

# each `RUN` statement applies a change to the container by executing
# the command in the container. Here we first update the package manager
# Then install a few external dependencies (python, pip, git and the
# mock library).
RUN sudo apt-get update
RUN sudo apt-get install -y python python-pip git
RUN pip install mock

# this installs the internally developed dependency (hellolib).
# From this project's point of view however there is no difference
# between internal and external.
RUN pip install git+https://github.com/OAODEV/hellolib.git

# This copies the project folder (from outside docker) into /app
# inside the container's filesystem
ADD . /hello

# Run all commands from this folder. This is where the service will be
# located after the last step copies the files in.
WORKDIR /hello/app

# until we get the automatic release management set up I'm having the Dockerfile
# handle setting environment variables from a settings file
RUN ls -al
RUN if ./ settings.sh; then echo "installed settings"; else echo "no settings found"; fi

# the default command to run when running this container. This should
# be the command to run the service as it will be what runs when the
# operations platform deploys the service.
CMD python serve_hello.py
