#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: extension.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 20:12:20 (CST)
# Last Update:星期日 2017-3-12 20:31:44 (CST)
#          By:
# Description:
# **************************************************************************
from flask import abort, current_app
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager


def register_login():
    login_manager = LoginManager()
    login_manager.login_view = "auth.login"
    login_manager.session_protection = "basic"
    login_manager.login_message = "Please login to access this page."

    @login_manager.user_loader
    def user_loader(id):
        from .server.models import User
        user = User.query.get(int(id))
        return user

    @login_manager.request_loader
    def user_loader_from_request(request):
        from .server.models import User
        config = current_app.config
        token = request.headers.get(config['LOGIN_TOKEN_HEADER'], None)
        if not token:
            token = request.args.get(config['LOGIN_TOKEN'], None)
        if token:
            user = User.check_user_token(token)
            if user and user.user_status == User.USER_STATUS_ACTIVED:
                return user

    @login_manager.unauthorized_handler
    def unauthorized():
        abort(403)

    return login_manager


db = SQLAlchemy()
login = register_login()
