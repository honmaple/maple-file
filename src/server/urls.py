#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: urls.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 20:15:42 (CST)
# Last Update:星期一 2017-3-13 14:38:36 (CST)
#          By:
# Description:
# **************************************************************************
from flask import Blueprint
from .views import ImageListView, ImageView, AlbumListView, AlbumView

site = Blueprint('image', __name__)

site.add_url_rule('/albums', view_func=AlbumListView.as_view('albums'))
site.add_url_rule('/albums/<int:pk>', view_func=AlbumView.as_view('album'))
site.add_url_rule('/images', view_func=ImageListView.as_view('images'))
site.add_url_rule('/images/<name>', view_func=ImageView.as_view('image'))
