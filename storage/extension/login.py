#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ********************************************************************************
# Copyright © 2019 jianglin
# File Name: login.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2019-01-07 13:55:26 (CST)
# Last Update: Wednesday 2019-01-09 12:00:45 (CST)
#          By:
# Description:
# ********************************************************************************
from flask import abort, current_app
from flask_login import LoginManager

login_manager = LoginManager()
login_manager.login_view = "auth.login"
login_manager.session_protection = "basic"
login_manager.login_message = "Please login to access this page."


@login_manager.user_loader
def user_loader(id):
    from storage.auth.model import User
    user = User.query.get(int(id))
    return user


@login_manager.request_loader
def user_loader_from_request(request):
    from storage.auth.model import User
    config = current_app.config
    token = request.headers.get(config['LOGIN_TOKEN_HEADER'])
    if not token:
        token = request.args.get(config['LOGIN_TOKEN'])
    if not token:
        return
    user = User.check_api_key(token)
    if not user:
        return
    user.login(remember=True)
    return user


@login_manager.unauthorized_handler
def unauthorized():
    abort(403)


def init_app(app):
    login_manager.init_app(app)
