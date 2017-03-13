# !/usr/bin/env python
# -*- coding: utf-8 -*-
# *************************************************************************
#   Copyright © 2015 JiangLin. All rights reserved.
#   File Name: db_create.py
#   Author:JiangLin
#   Mail:xiyang0807@gmail.com
#   Created Time: 2016-02-11 13:34:38
# *************************************************************************
from flask_script import Manager
from flask_migrate import Migrate, MigrateCommand
from runserver import app
from getpass import getpass
from storage.extension import db
from storage.server.models import User, Album

migrate = Migrate(app, db)
manager = Manager(app)


@manager.command
def run():
    return app.run()


@manager.command
def init_db():
    """
    Drops and re-creates the SQL schema
    """
    # db.drop_all()
    db.configure_mappers()
    db.create_all()
    db.session.commit()


@manager.option('-u', '--username', dest='username')
@manager.option('-e', '--email', dest='email')
@manager.option('-p', '--password', dest='password')
def create_user(username, email, password):
    if username is None:
        username = input('Username(default admin):') or 'admin'
    if email is None:
        email = input('Email:')
    if password is None:
        password = getpass('Password:')
    user = User(username=username, email=email)
    user.is_superuser = True
    user.key = user.api_key
    user.set_password(password)
    user.save()
    album = Album(name='default', user=user)
    album.save()


@manager.option('-u', '--username', dest='username')
@manager.option('-r', '--reset', dest='reset', default=False)
def key(username, reset):
    if username is None:
        username = input('Username(default admin):') or 'admin'
    user = User.query.filter_by(username=username).first()
    if reset:
        user.key = user.api_key
        user.save()
    print(user.key)


manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()
