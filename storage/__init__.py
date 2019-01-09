#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2019 jianglin
# File Name: __init__.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2017-03-12 20:16:21 (CST)
# Last Update: Wednesday 2019-01-09 14:12:04 (CST)
#          By:
# Description:
# **************************************************************************
from flask import Flask
from storage import auth, server, admin, extension, router


def create_app(config):
    app = Flask(__name__)
    app.config.from_object(config)
    extension.init_app(app)
    auth.init_app(app)
    server.init_app(app)
    admin.init_app(app)
    router.init_app(app)
    return app
