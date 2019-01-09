#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2019 jianglin
# File Name: runserver.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2017-03-12 19:53:43 (CST)
# Last Update: Wednesday 2019-01-09 14:18:24 (CST)
#          By:
# Description:
# **************************************************************************
from flask import current_app
from flask.cli import FlaskGroup, run_command
from werkzeug.contrib.fixers import ProxyFix
from code import interact
from datetime import timedelta

from storage import create_app
from storage.extension import db
from storage.server.model import Album
from storage.auth.model import User

import requests
import click
import os
import sys

DEFAULT_HOST = 'http://127.0.0.1:8000'
DEFAULT_KEY = 'IjEyMzQ1Ig.XDWNHw.uLdy7jFgNZpM7bhgpAeRasqnM'


class Config(object):
    DEBUG = True
    SECRET_KEY = 'ccc'
    SECRET_KEY_SALT = 'ssss'
    JSON_AS_ASCII = False

    PERMANENT_SESSION_LIFETIME = timedelta(days=3)

    PER_PAGE = 10
    ADMIN_URL = '/admin'

    LOGIN_TOKEN_HEADER = 'Api-Key'
    LOGIN_TOKEN = 'api_key'

    MIDDLEWARE = ['flask_maple.middleware.RequestMiddleware']

    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_DATABASE_URI = 'sqlite:///test.db'
    # SQLALCHEMY_ECHO = DEBUG
    UPLOAD_ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])
    UPLOAD_FOLDER_ROOT = os.path.dirname(os.path.abspath(__file__))
    UPLOAD_FOLDER_PATH = 'images'
    UPLOAD_FOLDER = os.path.join(UPLOAD_FOLDER_ROOT, UPLOAD_FOLDER_PATH)


app = create_app(Config())
app.wsgi_app = ProxyFix(app.wsgi_app)

cli = FlaskGroup(add_default_commands=False, create_app=lambda r: app)
cli.add_command(run_command)

try:
    from flask_migrate import Migrate
    migrate = Migrate(app, db)
except ImportError:
    pass


@cli.command('shell', short_help='Starts an interactive shell.')
def shell_command():
    ctx = current_app.make_shell_context()
    interact(local=ctx)


@cli.command()
@click.option('-p', '--port', default=8000)
def runserver(port):
    app.run(port=port)


@cli.command()
def initdb():
    """
    Drops and re-creates the SQL schema
    """
    db.drop_all()
    db.configure_mappers()
    db.create_all()
    db.session.commit()


@cli.command(short_help='Create user.')
@click.option('-u', '--username', prompt=True, default="admin")
@click.option('-e', '--email', prompt=True)
@click.password_option('-p', '--password')
def create_user(username, email, password):
    user = User(username=username, email=email)
    user.is_superuser = True
    user.key = user.api_key
    user.set_password(password)
    user.save()
    album = Album(name='default', user=user)
    album.save()


@cli.command()
@click.option('-u', '--username', prompt=True, default="admin")
@click.option('-r', '--reset', is_flag=True)
def key(username, reset=False):
    user = User.query.filter_by(username=username).first()
    if user and reset:
        user.key = user.api_key
        user.save()
    if not user:
        print("username not found")
    else:
        print(user.key)


@cli.command()
@click.option('-h', '--host', default=DEFAULT_HOST)
@click.option('-k', '--key', default=DEFAULT_KEY)
@click.option('-f', '--files', multiple=True)
def upload(host, key, files):
    url = host + '/api/images'
    multiple_files = []
    for f in files:
        i = ('images', (os.path.basename(f), open(f, 'rb'), 'image/png'))
        multiple_files.append(i)

    headers = {
        'Api-Key': key,
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36'
    }
    r = requests.post(url, files=multiple_files, headers=headers)
    print(r.text)


@cli.command()
@click.option('-h', '--host', default=DEFAULT_HOST)
@click.option('-u', '--username', prompt=True, default="admin")
@click.password_option('-p', "--password")
def login(host, username, password):
    url = host + '/api/login'
    data = {'username': username, 'password': password}
    r = requests.post(url, data=data)
    print(r.text)


if __name__ == '__main__':
    if len(sys.argv) == 1:
        app.run(port=8000)
    else:
        cli.main()
