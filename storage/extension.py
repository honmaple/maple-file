#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: extension.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 20:12:20 (CST)
# Last Update:星期五 2017-4-21 22:43:27 (CST)
#          By:
# Description:
# **************************************************************************
from flask import abort, current_app
from .common.models import db
from flask_login import LoginManager, login_user
from werkzeug import import_string


class Middleware(object):
    def __init__(self, app=None):
        self.app = app
        if app is not None:
            self.init_app(app)

    def init_app(self, app):
        middleware = app.config.setdefault('MIDDLEWARE', [])
        self.process(app, middleware)

    def process(self, app, middleware):
        for middleware_string in middleware:
            middleware = import_string(middleware_string)
            response = middleware()
            if hasattr(response, 'preprocess_request'):
                before_request = response.preprocess_request
                app.before_request(before_request)
            if hasattr(response, 'process_response'):
                after_request = response.process_response
                app.after_request(after_request)


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
            user = User.check_api_key(token)
            if user:
                login_user(user=user, remember=True)
                return user

    @login_manager.unauthorized_handler
    def unauthorized():
        abort(403)

    return login_manager


db = db
login = register_login()
middleware = Middleware()
