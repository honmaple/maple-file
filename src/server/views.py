#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: api.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 19:54:12 (CST)
# Last Update:星期一 2017-3-13 17:34:13 (CST)
#          By:
# Description:
# **************************************************************************
from flask import request, current_app
from datetime import datetime
from time import time
from random import randint
from threading import Thread
from PIL import Image as ImagePIL
from src.common.serializer import PageInfo
from src.common.views import IsAuthMethodView as MethodView
from src.common.response import HTTPResponse
from src.serializers import (ImageSerializer, AlbumSerializer)
from src.common.utils import gen_filter_dict, gen_order_by
from .models import Image, Album
import os


class AlbumListView(MethodView):
    def get(self):
        '''
        获取相册列表
        '''
        query_dict = request.data
        user = request.user
        page, number = self.page_info
        keys = ['name', 'description']
        order_by = gen_order_by(query_dict, keys)
        filter_dict = gen_filter_dict(query_dict, keys, user=user)
        albums = Album.query.filter_by(
            **filter_dict).order_by(*order_by).paginate(page, number)
        serializer = AlbumSerializer(albums.items, True)
        pageinfo = PageInfo(albums)
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS,
            data=serializer.data,
            pageinfo=pageinfo).to_response()

    def post(self):
        '''
        新建相册
        '''
        post_data = request.data
        user = request.user
        name = post_data.pop('name', None)
        description = post_data.pop('description', None)
        if name is None:
            msg = '相册名称不能为空'
            return HTTPResponse(
                HTTPResponse.HTTP_CODE_PARA_ERROR, message=msg).to_response()
        album = Album(name=name, user=user)
        if description is not None:
            album.description = description
        album.save()
        serializer = AlbumSerializer(album)
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS, data=serializer.data).to_response()


class AlbumView(MethodView):
    def get(self, pk):
        '''
        获取具体相册
        '''
        user = request.user
        album = Album.query.filter_by(id=pk, user=user).first()
        if not album:
            msg = '相册不存在'
            return HTTPResponse(
                HTTPResponse.HTTP_CODE_NOT_EXIST, message=msg).to_response()
        serializer = AlbumSerializer(album)
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS, data=serializer.data).to_response()

    def put(self, pk):
        '''
        修改相册
        '''
        post_data = request.data
        user = request.user
        name = post_data.pop('name', None)
        description = post_data.pop('description', None)
        album = Album.query.filter_by(id=pk, user=user).first()
        if not album:
            msg = '相册不存在'
            return HTTPResponse(
                HTTPResponse.HTTP_CODE_NOT_EXIST, message=msg).to_response()
        if name is not None:
            album.name = name
        if description is not None:
            album.description = description
        album.save()
        serializer = AlbumSerializer(album)
        album.delete()
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS, data=serializer.data).to_response()

    def delete(self, pk):
        '''
        删除具体相册
        '''
        user = request.user
        album = Album.query.filter_by(id=pk, user=user).first()
        if not album:
            msg = '相册不存在'
            return HTTPResponse(
                HTTPResponse.HTTP_CODE_NOT_EXIST, message=msg).to_response()
        serializer = AlbumSerializer(album)
        album.delete()
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS, data=serializer.data).to_response()


class ImageListView(MethodView):
    def get(self):
        '''
        获取图片列表
        '''
        query_dict = request.data
        user = request.user
        page, number = self.page_info
        keys = ['name', 'description']
        order_by = gen_order_by(query_dict, keys)
        filter_dict = gen_filter_dict(query_dict, keys, user=user)
        album = query_dict.pop('album', None)
        if album is not None:
            filter_dict.update(album__id=album)
        images = Image.query.filter_by(
            **filter_dict).order_by(*order_by).paginate(page, number)
        serializer = ImageSerializer(images.items, True)
        pageinfo = PageInfo(images)
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS,
            data=serializer.data,
            pageinfo=pageinfo).to_response()

    def post(self):
        '''
        上传图片
        '''
        user = request.user
        post_data = request.data
        album = post_data.pop('album', None)
        # 相册
        if album is not None:
            album = Album.query.filter_by(id=album, user=user).first()
        if not album:
            default_album = Album.query.filter_by(
                name='default', user=user).first()
            if not default_album:
                default_album = Album(name='default', user=user)
                default_album.save()
            album = default_album
        images = request.files.getlist('images')
        t = datetime.now()
        # 将会保存到数据库中的路径
        path = os.path.join(current_app.config['UPLOAD_FOLDER_PATH'], 'photo',
                            t.strftime('%Y'), t.strftime('%m'))
        # 将会保存到磁盘中的路径
        base_path = os.path.join(current_app.config['UPLOAD_FOLDER_ROOT'],
                                 path)
        if not os.path.exists(base_path):
            os.makedirs(base_path)
        _images = []
        for image in images:
            name = '{name}.png'.format(
                name=str(int(time() * 1000)) + str(randint(10, 99)))
            # 保存到磁盘中
            img_path = os.path.join(base_path, name)
            image.save(img_path)
            # 保存到数据库中
            img = Image(name=name, path=path, user=user, album=album)
            img.url = os.path.join(path, name)
            img.save()
            serializer = ImageSerializer(img)
            _images.append(serializer.data)
            # 缩略图路径
            thumb_path = os.path.join(current_app.config['UPLOAD_FOLDER_ROOT'],
                                      img_path.replace('photo', 'thumb'))
            t = Thread(
                target=self.gen_thumb_image, args=(img_path, thumb_path))
            t.setDaemon(True)
            t.start()
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS, data=_images).to_response()

    def gen_thumb_image(self, img_path, thumb_path):
        '''
        生成缩略图
        '''
        base_path = os.path.dirname(thumb_path)
        if not os.path.exists(base_path):
            os.makedirs(base_path)
        img = ImagePIL.open(img_path)
        if img.size[0] <= 300:
            img.save(thumb_path, 'PNG')
            return thumb_path
        width = 300
        height = float(width) / img.size[0] * img.size[1]
        img.thumbnail((width, height), ImagePIL.ANTIALIAS)
        img.save(thumb_path, 'PNG')
        return thumb_path


class ImageView(MethodView):
    def get(self, pk):
        '''
        显示图片
        '''
        user = request.user
        image = Image.query.filter_by(id=pk, user=user).first()
        if not image:
            msg = '图片不存在'
            return HTTPResponse(
                HTTPResponse.HTTP_CODE_NOT_EXIST, message=msg).to_response()
        serializer = ImageSerializer(image)
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS, data=serializer.data).to_response()

    def put(self, pk):
        '''
        修改图片信息
        '''
        post_data = request.data
        user = request.user
        name = post_data.pop('name', None)
        description = post_data.pop('description', None)
        image = Image.query.filter_by(id=pk, user=user).first()
        if not image:
            msg = '图片不存在'
            return HTTPResponse(
                HTTPResponse.HTTP_CODE_NOT_EXIST, message=msg).to_response()
        if name is not None:
            image.name = name
            image.url = os.path.join(image.path, name)
        if description is not None:
            image.description = description
        image.save()
        serializer = ImageSerializer(image)
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS, data=serializer.data).to_response()

    def delete(self, pk):
        '''
        删除图片
        '''
        user = request.user
        image = Image.query.filter_by(id=pk, user=user).first()
        if not image:
            msg = '图片不存在'
            return HTTPResponse(
                HTTPResponse.HTTP_CODE_NOT_EXIST, message=msg).to_response()
        serializer = ImageSerializer(image)
        img_path = os.path.join(current_app.config['UPLOAD_FOLDER_ROOT'],
                                image.url)
        # 删除原图
        if os.path.exists(img_path):
            os.remove(img_path)
        # 删除缩略图
        thumb_path = os.path.join(current_app.config['UPLOAD_FOLDER_ROOT'],
                                  image.url.replace('photo', 'thumb'))
        if os.path.exists(thumb_path):
            os.remove(thumb_path)
        image.delete()
        return HTTPResponse(
            HTTPResponse.NORMAL_STATUS, data=serializer.data).to_response()
