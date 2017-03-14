#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: __init__.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 20:16:21 (CST)
# Last Update:星期二 2017-3-14 15:59:29 (CST)
#          By:
# Description:
# **************************************************************************
from flask import Flask
from .admin import admin
import os


def create_app(config):
    app = Flask(__name__)
    templates = os.path.abspath(
        os.path.join(os.path.dirname(__file__), os.pardir, 'templates'))
    static = os.path.abspath(
        os.path.join(os.path.dirname(__file__), os.pardir, 'static'))
    app = Flask(__name__, template_folder=templates, static_folder=static)
    app.config.from_object(config)
    register(app)
    return app


def register(app):
    from .server.urls import site as server_site
    from .auth.urls import site as auth_site
    app.register_blueprint(server_site, url_prefix='/api')
    app.register_blueprint(auth_site, url_prefix='/api')
    register_extensions(app)
    register_router(app)


def register_extensions(app):
    from .extension import db, login, middleware
    db.init_app(app)
    login.init_app(app)
    middleware.init_app(app)
    admin.index_view.url = app.config['ADMIN_URL']
    admin.init_app(app)


def register_router(app):
    from flask import make_response, send_from_directory, request
    from .common.utils import gen_thumb_image
    from .common.response import HTTPResponse

    @app.route('/images/<path:filename>')
    def photo(filename):
        config = app.config
        query_dict = request.data
        try:
            width = int(query_dict.pop('width', 0))
            height = int(query_dict.pop('height', 0))
            if width or height:
                img = os.path.join(config['UPLOAD_FOLDER'], filename)
                stream = gen_thumb_image(img, width, height)
                buf_value = stream.getvalue()
                response = make_response(buf_value)
                response.headers['Content-Type'] = 'image/jpeg'
                return response
            return send_from_directory(config['UPLOAD_FOLDER'], filename)
        except ValueError:
            msg = '参数必须为数字'
            return HTTPResponse(
                HTTPResponse.HTTP_CODE_PARA_ERROR, message=msg).to_response()
