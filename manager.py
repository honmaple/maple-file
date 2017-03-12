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
from src.extension import db

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
    db.drop_all()
    db.configure_mappers()
    db.create_all()
    db.session.commit()


manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()
