#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2019 jianglin
# File Name: router.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2017-03-12 19:54:12 (CST)
# Last Update: Monday 2019-01-07 15:17:42 (CST)
#          By:
# Description:
# **************************************************************************
from flask import request, current_app
from flask_maple.response import HTTP
from flask_maple.serializer import PageInfo
from flask_maple.views import IsAuthMethodView as MethodView
from datetime import datetime
from time import time
from random import randint
from threading import Thread
from PIL import Image as ImagePIL
from storage.serializer import (ImageSerializer, AlbumSerializer)
from storage.util import (gen_filter_dict, gen_order_by, gen_hash,
                          file_is_allowed)
from .model import Image, Album
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
        return HTTP.OK(data=serializer.data, pageinfo=pageinfo)

    def post(self):
        '''
        新建相册
        '''
        post_data = request.data
        user = request.user
        name = post_data.pop('name', None)
        description = post_data.pop('description', None)
        if name is None:
            return HTTP.BAD_REQUEST(message='相册名称不能为空')
        album = Album(name=name, user=user)
        if description is not None:
            album.description = description
        album.save()
        serializer = AlbumSerializer(album)
        return HTTP.OK(data=serializer.data)


class AlbumView(MethodView):
    def get(self, pk):
        '''
        获取具体相册
        '''
        user = request.user
        album = Album.query.filter_by(id=pk, user=user).get_or_404('相册不存在')
        serializer = AlbumSerializer(album)
        return HTTP.OK(data=serializer.data)

    def put(self, pk):
        '''
        修改相册
        '''
        post_data = request.data
        user = request.user
        name = post_data.pop('name', None)
        description = post_data.pop('description', None)
        album = Album.query.filter_by(id=pk, user=user).get_or_404('相册不存在')
        if name is not None:
            album.name = name
        if description is not None:
            album.description = description
        album.save()
        serializer = AlbumSerializer(album)
        album.delete()
        return HTTP.OK(data=serializer.data)

    def delete(self, pk):
        '''
        删除具体相册
        '''
        user = request.user
        album = Album.query.filter_by(id=pk, user=user).get_or_404('相册不存在')
        serializer = AlbumSerializer(album)
        album.delete()
        return HTTP.OK(data=serializer.data)


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
        return HTTP.OK(data=serializer.data, pageinfo=pageinfo)

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
        path = os.path.join(current_app.config['UPLOAD_FOLDER_PATH'],
                            user.username, 'photo', t.strftime('%Y'),
                            t.strftime('%m'))
        # 将会保存到磁盘中的路径
        base_path = os.path.join(current_app.config['UPLOAD_FOLDER_ROOT'],
                                 path)
        if not os.path.exists(base_path):
            os.makedirs(base_path)
        success_images = []
        fail_images = []
        for image in images:
            if not file_is_allowed(image.filename):
                msg = '{name} 不允许的扩展'.format(name=image.filename)
                return HTTP.BAD_REQUEST(message=msg)
            name = '{name}.png'.format(
                name=str(int(time() * 1000)) + str(randint(10, 99)))
            # 计算sha-512值,避免重复保存
            hash = gen_hash(image)
            if Image.query.filter_by(hash=hash, user=user).exists():
                success_images.append(image.filename)
                continue

            # 保存到磁盘中
            img_path = os.path.join(base_path, name)
            # http://stackoverflow.com/questions/42569942/calculate-md5-from-werkzeug-datastructures-filestorage-but-saving-the-object-as
            image.seek(0)
            image.save(img_path)
            # 保存到数据库中
            img = Image(
                name=name, path=path, hash=hash, user=user, album=album)
            img.url = os.path.join(path, name)
            img.save()
            serializer = ImageSerializer(img)
            success_images.append(serializer.data)
            # 缩略图路径
            thumb_path = os.path.join(current_app.config['UPLOAD_FOLDER_ROOT'],
                                      img_path.replace('photo', 'thumb'))
            # 展示图路径
            show_path = os.path.join(current_app.config['UPLOAD_FOLDER_ROOT'],
                                     img_path.replace('photo', 'show'))
            t = Thread(
                target=self.gen_thumb_image, args=(img_path, thumb_path, 300))
            t.setDaemon(True)
            t.start()
            t = Thread(
                target=self.gen_thumb_image, args=(img_path, show_path, 810))
            t.setDaemon(True)
            t.start()

        return HTTP.OK(data={'success': success_images, 'fail': fail_images})

    def gen_thumb_image(self, img_path, thumb_path, width):
        '''
        生成缩略图 or 展示图
        '''
        base_path = os.path.dirname(thumb_path)
        if not os.path.exists(base_path):
            os.makedirs(base_path)
        img = ImagePIL.open(img_path)
        if img.size[0] <= width:
            img.save(thumb_path, 'PNG')
            return thumb_path
        width = width
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
        image = Image.query.filter_by(id=pk, user=user).get_or_404('图片不存在')
        serializer = ImageSerializer(image)
        return HTTP.OK(data=serializer.data)

    def put(self, pk):
        '''
        修改图片信息
        '''
        post_data = request.data
        user = request.user
        name = post_data.pop('name', None)
        description = post_data.pop('description', None)
        image = Image.query.filter_by(id=pk, user=user).get_or_404('图片不存在')
        if name is not None:
            image.name = name
            image.url = os.path.join(image.path, name)
        if description is not None:
            image.description = description
        image.save()
        serializer = ImageSerializer(image)
        return HTTP.OK(data=serializer.data)

    def delete(self, pk):
        '''
        删除图片
        '''
        user = request.user
        image = Image.query.filter_by(id=pk, user=user).get_or_404('图片不存在')
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
        return HTTP.OK(data=serializer.data)
