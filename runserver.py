#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: runserver.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 19:53:43 (CST)
# Last Update:星期日 2017-3-12 21:4:13 (CST)
#          By:
# Description:
# **************************************************************************
from src import create_app
from datetime import timedelta


class Config(object):
    DEBUG = True
    SECRET_KEY = 'ccc'
    SECURITY_PASSWORD_SALT = 'ssss'

    PERMANENT_SESSION_LIFETIME = timedelta(days=3)

    PER_PAGE = 6

    LOGIN_TOKEN_HEADER = 'Token'
    LOGIN_TOKEN = 'token'
    AUTH_HEADER_NAME = 'token'

    WTF_CSRF_ENABLED = True

    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_DATABASE_URI = 'sqlite:///test.db'
    # SQLALCHEMY_ECHO = DEBUG


app = create_app(Config())

if __name__ == '__main__':
    app.run()
