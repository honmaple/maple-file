#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2019 jianglin
# File Name: model.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2017-03-12 19:58:08 (CST)
# Last Update: Monday 2019-01-07 14:36:30 (CST)
#          By:
# Description:
# **************************************************************************
from flask_maple.models import ModelUserMixin
from storage.extension import db


class Album(ModelUserMixin, db.Model):
    __tablename__ = 'album'
    user_related_name = 'albums'
    name = db.Column(db.String(108), nullable=False)
    description = db.Column(db.String(1024), default='album')

    def __repr__(self):
        return '<Album %r>' % self.name

    def __str__(self):
        return self.name


class Image(ModelUserMixin, db.Model):
    __tablename__ = 'image'
    user_related_name = 'images'
    name = db.Column(db.String(108), nullable=False)
    path = db.Column(db.String(512), nullable=False)
    url = db.Column(db.String(512), nullable=False)
    hash = db.Column(db.String(1024), nullable=False)
    description = db.Column(db.String(1024), default='image')
    album_id = db.Column(db.Integer,
                         db.ForeignKey('album.id', ondelete="CASCADE"))
    album = db.relationship(
        Album,
        backref=db.backref(
            'images', cascade='all,delete-orphan', lazy='dynamic'),
        uselist=False,
        lazy='joined')

    def __repr__(self):
        return '<Image %r>' % self.name

    def __str__(self):
        return self.name
