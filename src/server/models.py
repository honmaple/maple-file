#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: models.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 19:58:08 (CST)
# Last Update:星期一 2017-3-13 17:38:22 (CST)
#          By:
# Description:
# **************************************************************************
from flask import current_app
from flask_login import UserMixin
from werkzeug.security import (generate_password_hash, check_password_hash)
from itsdangerous import (URLSafeTimedSerializer, BadSignature,
                          SignatureExpired)
from src.extension import db
from src.common.models import ModelUserMixin, ModelMixin


class User(ModelMixin, UserMixin, db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(108), unique=True)
    password = db.Column(db.String(108), nullable=False)
    email = db.Column(db.String(108), unique=True)
    key = db.Column(db.String(108), unique=True)
    is_superuser = db.Column(db.Boolean, default=False)

    def set_password(self, raw_password):
        self.password = generate_password_hash(raw_password)

    def check_password(self, raw_password):
        return check_password_hash(self.password, raw_password)

    @property
    def api_key(self):
        config = current_app.config
        secret_key = config['SECRET_KEY']
        salt = config['SECRET_KEY_SALT']
        serializer = URLSafeTimedSerializer(secret_key, salt=salt)
        token = serializer.dumps(self.email)
        return token

    @classmethod
    def check_api_key(cls, token, max_age=7776000):
        '''
        max_age is three months
        '''
        config = current_app.config
        secret_key = config['SECRET_KEY']
        salt = config['SECRET_KEY_SALT']
        serializer = URLSafeTimedSerializer(secret_key, salt=salt)
        try:
            email = serializer.loads(token, max_age=max_age)
        except BadSignature:
            return False
        except SignatureExpired:
            return False
        user = cls.query.filter_by(email=email, key=token).first()
        if user is None:
            return False
        return user

    def __repr__(self):
        return '<User %r>' % self.username

    def __str__(self):
        return self.username


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
    description = db.Column(db.String(1024), default='image')
    album_id = db.Column(
        db.Integer, db.ForeignKey(
            'album.id', ondelete="CASCADE"))
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
