#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: admin.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 20:18:22 (CST)
# Last Update:星期一 2017-3-13 16:32:32 (CST)
#          By:
# Description:
# **************************************************************************
from flask import url_for, Markup, request
from flask_admin import form
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
    column_display_pk = True
    form_base_class = BaseForm

    # def is_accessible(self):
    #     if current_user.is_authenticated and current_user.is_superuser:
    #         return True
    #     return False

    # def inaccessible_callback(self, name, **kwargs):
    #     abort(404)


# class ImageView(BaseView):
#     def _list_thumbnail(view, context, model, name):
#         if not model.path:
#             return ''
#         return Markup('<img src="%s">' % url_for(
#             'images', filename=form.thumbgen_filename(model.url)))

#     column_formatters = {'path': _list_thumbnail}
#     form_excluded_columns = ['url']
#     form_extra_fields = {
#         'path': form.ImageUploadField(
#             'Image',
#             base_path=file_path,
#             namegen=prefix_name,
#             thumbnail_size=(100, 100, True))
#     }


admin.add_view(
    BaseView(
        User, db.session, name='管理用户', endpoint='admin_user', url='users'))
admin.add_view(
    BaseView(
        Album, db.session, name='管理相册', endpoint='admin_album', url='albums'))
admin.add_view(
    BaseView(
        Image, db.session, name='管理图片', endpoint='admin_image', url='images'))
