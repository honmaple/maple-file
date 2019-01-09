#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ********************************************************************************
# Copyright © 2019 jianglin
# File Name: model.py
# Author: jianglin
# Email: mail@honmaple.com
# Created: 2019-01-07 14:15:05 (CST)
# Last Update: Wednesday 2019-01-09 13:52:46 (CST)
#          By:
# Description:
# ********************************************************************************
from flask import current_app
from flask_login import UserMixin, login_user, logout_user
from flask_maple.models import ModelMixin
from werkzeug.security import generate_password_hash, check_password_hash
from itsdangerous import (URLSafeTimedSerializer, BadSignature,
                          SignatureExpired)
from storage.extension import db


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
        return self.password

    def check_password(self, raw_password):
        return check_password_hash(self.password, raw_password)

    @classmethod
    def _token_serializer(cls, key=None, salt=None):
        config = current_app.config
        if key is None:
            key = config['SECRET_KEY']
        if salt is None:
            salt = config['SECRET_KEY_SALT']
        return URLSafeTimedSerializer(key, salt=salt)

    @property
    def api_key(self):
        serializer = self._token_serializer()
        token = serializer.dumps(self.email)
        return token

    @classmethod
    def check_api_key(cls, token, max_age=7776000):
        '''
        max_age is three months
        '''
        serializer = cls._token_serializer()
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

    @property
    def is_logined(self):
        return self.is_authenticated

    def login(self, remember=True):
        login_user(self, remember)

    def logout(self):
        logout_user()

    def __repr__(self):
        return '<User %r>' % self.username

    def __str__(self):
        return self.username
