@echo off
pushd ..\
pipenv run python Testing/main.py
popd
PAUSE