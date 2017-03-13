#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: urls.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-13 20:35:08 (CST)
# Last Update:星期一 2017-3-13 20:36:33 (CST)
#          By:
# Description:
# **************************************************************************
from flask import Blueprint
from .views import LoginView, LogoutView

site = Blueprint('auth', __name__)

site.add_url_rule('/login', view_func=LoginView.as_view('login'))
site.add_url_rule('/logout', view_func=LogoutView.as_view('logout'))
