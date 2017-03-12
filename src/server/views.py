#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: api.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 19:54:12 (CST)
# Last Update:星期日 2017-3-12 20:59:35 (CST)
#          By:
# Description:
# **************************************************************************
from flask import render_template
from flask.views import MethodView
from .models import Image, Album


class AlbumListView(MethodView):
    def get(self):
        '''
        获取相册列表
        '''

    def post(self):
        '''
        新建相册
        '''


class ImageListView(MethodView):
    def get(self):
        '''
        获取图片列表
        '''
        images = Image.query.paginate(1, 10)
        print(images.items)
        return render_template('images.html', images=images)

    def post(self):
        '''
        上传图片
        '''


class ImageView(MethodView):
    def get(self, name):
        '''
        显示图片
        '''

    def delete(self, name):
        '''
        删除图片
        '''
