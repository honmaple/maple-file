#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2019 jianglin
# File Name: serializer.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2017-03-13 13:23:26 (CST)
# Last Update: Monday 2019-01-07 14:36:30 (CST)
#          By:
# Description:
# **************************************************************************
from flask_maple.serializer import Serializer


class UserSerializer(Serializer):
    class Meta:
        include = ['id', 'username', 'key']


class AlbumSerializer(Serializer):
    class Meta:
        exclude = ['user', 'images']


class ImageSerializer(Serializer):
    class Meta:
        exclude = ['user', 'hash']
