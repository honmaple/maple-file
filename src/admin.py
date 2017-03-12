#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: admin.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 20:18:22 (CST)
# Last Update:星期日 2017-3-12 20:31:3 (CST)
#          By:
# Description:
# **************************************************************************
from flask_wtf import Form
from flask_admin import Admin
from flask_admin.contrib.sqla import ModelView
from .server.models import User, Album, Image
from src.extension import db

admin = Admin(name='图片管理', template_mode='bootstrap3')


class BaseForm(Form):
    def __init__(self, formdata=None, obj=None, prefix=u'', **kwargs):
        self._obj = obj
        super(BaseForm, self).__init__(
            formdata=formdata, obj=obj, prefix=prefix, **kwargs)


class BaseView(ModelView):

    page_size = 10
    can_view_details = True
    # column_display_pk = True
    form_base_class = BaseForm

    # def is_accessible(self):
    #     if current_user.is_authenticated and current_user.is_superuser:
    #         return True
    #     return False

    # def inaccessible_callback(self, name, **kwargs):
    #     abort(404)


admin.add_view(
    BaseView(
        User, db.session, name='管理用户', endpoint='admin_user', url='users'))
admin.add_view(
    BaseView(
        Album, db.session, name='管理相册', endpoint='admin_album', url='albums'))
admin.add_view(
    BaseView(
        Image, db.session, name='管理图片', endpoint='admin_image', url='images'))
