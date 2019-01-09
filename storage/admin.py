#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2019 jianglin
# File Name: admin.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2017-03-12 20:18:22 (CST)
# Last Update: Wednesday 2019-01-09 14:20:18 (CST)
#          By:
# Description:
# **************************************************************************
from random import randint
from time import time

from flask import Markup, abort, current_app
from flask_admin import Admin, form
from flask_admin.contrib.sqla import ModelView
from flask_login import current_user

from storage.util import gen_hash
from storage.extension import db

from storage.server.model import Album, Image
from storage.auth.model import User

admin = Admin(name='图片管理', template_mode='bootstrap3')


class BaseView(ModelView):

    page_size = 10
    can_view_details = True

    # column_display_pk = True
    # form_base_class = BaseForm

    def is_accessible(self):
        if current_user.is_authenticated and current_user.is_superuser:
            return True
        return False

    def inaccessible_callback(self, name, **kwargs):
        abort(404)


class UserView(BaseView):
    column_exclude_list = ['password']
    column_editable_list = ['is_superuser']

    def on_model_change(self, form, model, is_created=False):
        if is_created:
            model.key = model.api_key
            model.password = User.set_password(form.password.data)


class AlbumView(BaseView):
    column_editable_list = ['name']


class ImageView(BaseView):
    def _list_thumbnail(view, context, model, name):
        return Markup('<img src="/%s">' % model.url.replace('photo', 'thumb'))

    def prefix_name(obj, file_data):
        name = '{name}.png'.format(
            name=str(int(time() * 1000)) + str(randint(10, 99)))
        return name

    column_formatters = {'url': _list_thumbnail}
    column_exclude_list = ['hash', 'path']
    form_excluded_columns = ['hash', 'path']
    form_extra_fields = {
        'url': form.ImageUploadField(
            'Image',
            base_path=lambda: current_app.config['UPLOAD_FOLDER'],
            namegen=prefix_name,
            thumbnail_size=(100, 100, True))
    }

    def on_model_change(self, form, model, is_created=False):
        if is_created:
            model.hash = gen_hash(form.url.data)


def init_app(app):
    admin.add_view(
        UserView(
            User, db.session, name='管理用户', endpoint='admin_user', url='users'))
    admin.add_view(
        AlbumView(
            Album,
            db.session,
            name='管理相册',
            endpoint='admin_album',
            url='albums'))
    admin.add_view(
        ImageView(
            Image,
            db.session,
            name='管理图片',
            endpoint='admin_image',
            url='images'))
    admin.index_view.url = app.config['ADMIN_URL']
    admin.init_app(app)
