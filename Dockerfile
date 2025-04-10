ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:latest-em
FROM $IMAGE

USER root

# create directory to copy files into image
WORKDIR /opt/irisapp
RUN chown -R irisowner:irisowner /opt/irisapp

USER irisowner

# copy files to image
WORKDIR /opt/irisapp
RUN mkdir -p /opt/irisapp/db
COPY --chown=irisowner:irisowner install install
COPY --chown=irisowner:irisowner iris.script iris.script
COPY --chown=irisowner:irisowner ns-interop ns-interop
COPY --chown=irisowner:irisowner ns-fhirrepo ns-fhirrepo
COPY --chown=irisowner:irisowner ns-user ns-user

# run iris.script
RUN iris start IRIS \
    && iris session IRIS < /opt/irisapp/iris.script \
    && iris stop IRIS quietly