#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2016 jianglin
# File Name: response.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2016-12-25 11:21:35 (CST)
# Last Update:星期一 2017-3-13 16:46:17 (CST)
#          By:
# Description:
# **************************************************************************
from flask import jsonify


class HTTPResponse(object):

    NORMAL_STATUS = '200'
    FORBIDDEN = '403'
    HTTP_CODE_PARA_ERROR = '401'
    HTTP_CODE_NOT_EXIST = '404'
    OTHER_ERROR = '500'

    STATUS_DESCRIPTION = {
        NORMAL_STATUS: 'normal',
        HTTP_CODE_NOT_EXIST: '404',
        HTTP_CODE_PARA_ERROR: '参数错误',
        OTHER_ERROR: '其它错误'
    }

    def __init__(self,
                 status='200',
                 message='',
                 data=None,
                 description='',
                 pageinfo=None):
        self.status = status
        self.message = self.STATUS_DESCRIPTION.get(status)
        self.data = data
        self.description = description
        self.pageinfo = pageinfo

    def to_dict(self):
        response = {
            'status': self.status,
            'message': self.message,
            'data': self.data,
            'description': self.description,
        }
        if self.pageinfo is not None:
            response.update(pageinfo=self.pageinfo.as_dict())
        return response

    def to_response(self):
        response = self.to_dict()
        return jsonify(response)
