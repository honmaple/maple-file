#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: models.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-12 19:58:08 (CST)
# Last Update:星期日 2017-3-12 21:0:6 (CST)
#          By:
# Description:
# **************************************************************************
from flask import current_app
from sqlalchemy.ext.declarative import declared_attr
from datetime import datetime
from werkzeug.security import (generate_password_hash, check_password_hash)
from itsdangerous import (URLSafeTimedSerializer, BadSignature,
                          SignatureExpired)
from src.extension import db


class CommonMixin(object):
    @declared_attr
    def id(cls):
        return db.Column(db.Integer, primary_key=True)

    @declared_attr
    def created_at(cls):
        return db.Column(db.DateTime, default=datetime.utcnow())

    @declared_attr
    def updated_at(cls):
        return db.Column(
            db.DateTime, default=datetime.utcnow(), onupdate=datetime.utcnow())


class CommonUserMixin(CommonMixin):
    @declared_attr
    def user_id(cls):
        return db.Column(
            db.Integer, db.ForeignKey(
                'user.id', ondelete="CASCADE"))

    @declared_attr
    def user(cls):
        name = cls.__name__.lower()
        if not name.endswith('s'):
            name = name + 's'
        if hasattr(cls, 'user_related_name'):
            name = cls.user_related_name
        return db.relationship(
            User,
            backref=db.backref(
                name, cascade='all,delete', lazy='dynamic'),
            uselist=False,
            lazy='joined')


class User(db.Model):
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
        secret_key = config.setdefault('SECRET_KEY')
        salt = config.setdefault('SECRET_KEY_SALT')
        serializer = URLSafeTimedSerializer(secret_key)
        token = serializer.dumps(self.email, salt=salt)
        return token

    @classmethod
    def check_api_key(cls, token, max_age=86400):
        config = current_app.config
        secret_key = config.setdefault('SECRET_KEY')
        salt = config.setdefault('SECURITY_PASSWORD_SALT')
        serializer = URLSafeTimedSerializer(secret_key)
        try:
            email = serializer.loads(token, salt=salt, max_age=max_age)
        except BadSignature:
            return False
        except SignatureExpired:
            return False
        user = User.query.filter_by(email=email).first()
        if user is None:
            return False
        return user


class Album(CommonUserMixin, db.Model):
    __tablename__ = 'album'
    user_related_name = 'albums'
    name = db.Column(db.String(108), nullable=False)
    description = db.Column(db.String(1024), nullable=False)


class Image(CommonUserMixin, db.Model):
    __tablename__ = 'image'
    user_related_name = 'images'
    name = db.Column(db.String(108), nullable=False)
    description = db.Column(db.String(1024), nullable=False)
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
        return '<Images %r>' % self.name

    def __str__(self):
        return self.name
