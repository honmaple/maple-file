#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2016 jianglin
# File Name: response.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2016-12-25 11:21:35 (CST)
# Last Update:星期一 2017-3-13 14:35:0 (CST)
#          By:
# Description:
# **************************************************************************
from flask_maple.response import HTTPResponse as Response


class HTTPResponse(Response):

    AUTH_USER_OR_PASSWORD_ERROR = '600'
    AUTH_USERNAME_UNIQUE = '601'
    AUTH_EMAIL_UNIQUE = '602'

    HTTP_CLOUD_NOT_EXIST = '404'
    # 项目
    HTTP_CLOUD_PROJECT_NOT_EXIST = '701'

    HTTP_CLOUD_PARA_ERROR = '401'

    OTHER_ERROR = '900001'

    Response.STATUS_DESCRIPTION.update({
        HTTP_CLOUD_NOT_EXIST: '404',
        HTTP_CLOUD_PARA_ERROR: '参数错误',
        OTHER_ERROR: '其它错误'
    })
