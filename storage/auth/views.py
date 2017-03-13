#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: views.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-13 20:34:52 (CST)
# Last Update:星期一 2017-3-13 20:49:37 (CST)
#          By:
# Description:
# **************************************************************************
from flask import request
from flask.views import MethodView
from flask_login import login_user, logout_user, login_required
from storage.common.response import HTTPResponse
from storage.server.models import User
from storage.serializers import UserSerializer


class LoginView(MethodView):
    def post(self):
        '''
        登陆
        '''
        post_data = request.data
        username = post_data.pop('username', None)
        password = post_data.pop('password', None)
        remember = True
        if username and password:
            user = User.query.filter_by(username=username).first()
            if user and user.check_password(password):
                login_user(user, remember=remember)
                serializer = UserSerializer(user)
                data = serializer.data
                return HTTPResponse(
                    HTTPResponse.NORMAL_STATUS, data=data).to_response()
        return HTTPResponse(
            HTTPResponse.HTTP_CODE_PARA_ERROR,
            message='用户名或密码错误').to_response()


class LogoutView(MethodView):
    @login_required
    def get(self):
        logout_user()
        msg = '注销成功'
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS, description=msg).to_response()
