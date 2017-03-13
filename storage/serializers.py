#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: serializers.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-13 13:23:26 (CST)
# Last Update:星期一 2017-3-13 20:46:8 (CST)
#          By:
# Description:
# **************************************************************************
from .common.serializer import Serializer


class UserSerializer(Serializer):
    class Meta:
        include = ['id', 'username', 'key']


class AlbumSerializer(Serializer):
    class Meta:
        exclude = ['user', 'images']


class ImageSerializer(Serializer):
    class Meta:
        exclude = ['user', 'hash']
