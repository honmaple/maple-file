#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2019 jianglin
# File Name: __init__.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2017-03-13 20:34:48 (CST)
# Last Update: Monday 2019-01-07 14:36:30 (CST)
#          By:
# Description:
# **************************************************************************
from flask import Blueprint
from storage.auth.router import LoginView, LogoutView

site = Blueprint('auth', __name__)

site.add_url_rule('/login', view_func=LoginView.as_view('login'))
site.add_url_rule('/logout', view_func=LogoutView.as_view('logout'))


def init_app(app):
    app.register_blueprint(site, url_prefix='/api')
