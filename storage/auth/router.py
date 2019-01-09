#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2019 jianglin
# File Name: router.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2017-03-13 20:34:52 (CST)
# Last Update: Monday 2019-01-07 14:58:51 (CST)
#          By:
# Description:
# **************************************************************************
from flask import request
from flask.views import MethodView
from flask_login import login_user, logout_user, login_required
from flask_maple.response import HTTP
from storage.auth.model import User
from storage.serializer import UserSerializer


class LoginView(MethodView):
    def post(self):
        '''
        登陆
        '''
        post_data = request.data
        username = post_data.pop('username', None)
        password = post_data.pop('password', None)
        remember = post_data.pop('remember', True)
        if username and password:
            user = User.query.filter_by(username=username).first()
            if user and user.check_password(password):
                user.login(remember)
                serializer = UserSerializer(user)
                return HTTP.OK(data=serializer.data)
        return HTTP.UNAUTHORIZED(message='用户名或密码错误')


class LogoutView(MethodView):
    @login_required
    def get(self):
        user = request.user
        user.logout()
        return HTTP.OK(message='登出成功')
