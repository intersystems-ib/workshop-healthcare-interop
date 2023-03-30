FROM jupyter/minimal-notebook

# install IRIS DBAPI driver
RUN wget https://raw.githubusercontent.com/intersystems-community/iris-driver-distribution/main/DB-API/intersystems_irispython-3.2.0-py3-none-any.whl
RUN pip install intersystems_irispython-3.2.0-py3-none-any.whl

# install python libs
RUN pip install pandas numpy matplotlib