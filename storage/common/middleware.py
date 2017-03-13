#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: middleware.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-13 14:18:20 (CST)
# Last Update:星期一 2017-3-13 16:11:45 (CST)
#          By:
# Description:
# **************************************************************************
from flask import g, request
from flask_login import current_user


class CommonMiddleware(object):
    def preprocess_request(self):
        g.user = current_user
        request.user = current_user._get_current_object()
        if request.method == 'GET':
            request.data = request.args.to_dict()
        else:
            request.data = request.json
            if request.data is None:
                request.data = request.form.to_dict()
