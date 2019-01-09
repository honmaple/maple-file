#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2019 jianglin
# File Name: __init__.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2017-03-12 20:15:37 (CST)
# Last Update: Monday 2019-01-07 14:36:30 (CST)
#          By:
# Description:
# **************************************************************************
from flask import Blueprint
from storage.server.router import (ImageListView, ImageView, AlbumListView,
                                   AlbumView)

site = Blueprint('image', __name__)

site.add_url_rule('/albums', view_func=AlbumListView.as_view('albums'))
site.add_url_rule('/albums/<int:pk>', view_func=AlbumView.as_view('album'))
site.add_url_rule('/images', view_func=ImageListView.as_view('images'))
site.add_url_rule('/images/<int:pk>', view_func=ImageView.as_view('image'))


def init_app(app):
    app.register_blueprint(site, url_prefix='/api')
