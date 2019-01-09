#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ********************************************************************************
# Copyright © 2019 jianglin
# File Name: __init__.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2019-01-07 13:54:45 (CST)
# Last Update: Monday 2019-01-07 14:41:08 (CST)
#          By:
# Description:
# ********************************************************************************
from flask_maple.middleware import Middleware
from flask_maple.models import db
from storage.extension.login import login_manager


def init_app(app):
    db.init_app(app)
    login_manager.init_app(app)
    Middleware(app)
