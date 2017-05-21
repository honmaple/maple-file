#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: runserver.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 19:53:43 (CST)
# Last Update:星期四 2017-4-13 13:39:52 (CST)
#          By:
# Description:
# **************************************************************************
from storage import create_app
from datetime import timedelta
from werkzeug.contrib.fixers import ProxyFix
import os


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

    MIDDLEWARE = ['storage.common.middleware.CommonMiddleware']

    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_DATABASE_URI = 'sqlite:///test.db'
    # SQLALCHEMY_ECHO = DEBUG
    UPLOAD_ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])
    UPLOAD_FOLDER_ROOT = os.path.dirname(os.path.abspath(__file__))
    UPLOAD_FOLDER_PATH = 'images'
    UPLOAD_FOLDER = os.path.join(UPLOAD_FOLDER_ROOT, UPLOAD_FOLDER_PATH)


app = create_app(Config())
app.wsgi_app = ProxyFix(app.wsgi_app)

if __name__ == '__main__':
    app.run(port=8000)
