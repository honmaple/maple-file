#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ********************************************************************************
# Copyright © 2019 jianglin
# File Name: router.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2019-01-07 14:29:15 (CST)
# Last Update: Wednesday 2019-01-09 14:13:46 (CST)
#          By:
# Description:
# ********************************************************************************
from flask import current_app, make_response, request, send_from_directory
from flask.views import MethodView
from storage.util import gen_thumb_image

import os


class IMGView(MethodView):
    def get(self, filename):
        config = current_app.config
        width = request.args.get("width", 0, type=int)
        height = request.args.get("height", 0, type=int)
        if width or height:
            img = os.path.join(config['UPLOAD_FOLDER'], filename)
            stream = gen_thumb_image(img, width, height)
            buf_value = stream.getvalue()
            response = make_response(buf_value)
            response.headers['Content-Type'] = 'image/jpeg'
            return response
        return send_from_directory(config['UPLOAD_FOLDER'], filename)


def init_app(app):
    app.add_url_rule(
        "/images/<path:filename>", view_func=IMGView.as_view("image"))
