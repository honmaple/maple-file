#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: models.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-13 13:45:56 (CST)
# Last Update:星期一 2017-3-13 13:46:2 (CST)
#          By:
# Description:
# **************************************************************************
from flask_sqlalchemy import SQLAlchemy
from flask_sqlalchemy import BaseQuery, Model
from sqlalchemy.orm.exc import NoResultFound, MultipleResultsFound
from sqlalchemy import or_, and_
from sqlalchemy.orm import joinedload, joinedload_all, load_only
from sqlalchemy.orm.base import _entity_descriptor
from sqlalchemy.util import to_list
from sqlalchemy.sql import operators, extract
from sqlalchemy.ext.declarative import declared_attr
from datetime import datetime


class DoesNotExist(Exception):
    pass


class ObjectDoesNotExist(Exception):
    def __init__(self, model):
        self.model = model

    def __str__(self):
        return '%s DoesNotExist' % self.model.__name__


class QueryMixin(BaseQuery):
    _underscore_operators = {
        'gt': operators.gt,
        'lte': operators.lt,
        'gte': operators.ge,
        'le': operators.le,
        'contains': operators.contains_op,
        'in': operators.in_op,
        'exact': operators.eq,
        'iexact': operators.ilike_op,
        'startswith': operators.startswith_op,
        'istartswith': lambda c, x: c.ilike(x.replace('%', '%%') + '%'),
        'iendswith': lambda c, x: c.ilike('%' + x.replace('%', '%%')),
        'endswith': operators.endswith_op,
        'isnull': lambda c, x: x and c is not None or c is None,
        'range': operators.between_op,
        'year': lambda c, x: extract('year', c) == x,
        'month': lambda c, x: extract('month', c) == x,
        'day': lambda c, x: extract('day', c) == x
    }

    def filter_by(self, **kwargs):
        return self._filter_or_exclude(False, kwargs)

    def exclude_by(self, **kwargs):
        return self._filter_or_exclude(True, kwargs)

    def select_related(self, *columns, **options):
        depth = options.pop('depth', None)
        if options:
            raise TypeError('Unexpected argument %r' % iter(options).next())
        if depth not in (None, 1):
            raise TypeError('Depth can only be 1 or None currently')
        need_all = depth is None
        columns = list(columns)
        for idx, column in enumerate(columns):
            column = column.replace('__', '.')
            if '.' in column:
                need_all = True
            columns[idx] = column
        func = (need_all and joinedload_all or joinedload)
        return self.options(func(*columns))

    def order_by(self, *args):
        args = list(args)
        joins_needed = []
        for idx, arg in enumerate(args):
            q = self
            if not isinstance(arg, str):
                continue
            if arg[0] in '+-':
                desc = arg[0] == '-'
                arg = arg[1:]
            else:
                desc = False
            q = self
            column = None
            for token in arg.split('__'):
                column = _entity_descriptor(q._joinpoint_zero(), token)
                if column.impl.uses_objects:
                    q = q.join(column)
                    joins_needed.append(column)
                    column = None
            if column is None:
                raise ValueError('Tried to order by table, column expected')
            if desc:
                column = column.desc()
            args[idx] = column

        q = super(QueryMixin, self).order_by(*args)
        for join in joins_needed:
            q = q.join(join)
        return q

    def _filter_or_exclude(self, negate, kwargs):
        q = self

        def negate_if(expr):
            return expr if not negate else ~expr

        column = None

        for arg, value in kwargs.items():
            for token in arg.split('__'):
                if column is None:
                    column = _entity_descriptor(q._joinpoint_zero(), token)
                    if column.impl.uses_objects:
                        q = q.join(column)
                        column = None
                elif token in ['in']:
                    op = self._underscore_operators[token]
                    q = q.filter(negate_if(op(column, value)))
                    column = None
                elif token in self._underscore_operators:
                    op = self._underscore_operators[token]
                    q = q.filter(negate_if(op(column, *to_list(value))))
                    column = None
                else:
                    raise ValueError('No idea what to do with %r' % token)
            if column is not None:
                q = q.filter(negate_if(column == value))
                column = None
            q = q.reset_joinpoint()
        return q

    def load_only(self, *columns):
        return self.options(load_only(*columns))

    def or_(self, *kwargs):
        return self.filter(or_(*kwargs))

    def and_(self, *kwargs):
        return self.filter(and_(*kwargs))

    def exists(self):
        session = self.session
        return session.query(super(QueryMixin, self).exists()).scalar()

    # def one(self):
    #     return super(QueryMixin, self).one()

    # class CustomModel(Model):
    #     def __new__(self)


db = SQLAlchemy(query_class=QueryMixin)


class ModelMixin(object):
    NoResultFound = NoResultFound
    MultipleResultsFound = MultipleResultsFound

    @declared_attr
    def id(cls):
        return db.Column(db.Integer, primary_key=True)

    def save(self):
        if not self.id:
            db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    # @classmethod
    # def bulk_create(cls, instances):
    #     db.session.add_all(instances)
    #     db.session.commit()

    @classmethod
    def bulk_insert(cls, mappings, return_defaults=False):
        b = db.session.bulk_insert_mappings(cls, mappings, return_defaults)
        db.session.commit()
        return b

    @classmethod
    def bulk_update(cls, mappings):
        b = db.session.bulk_update_mappings(cls, mappings)
        db.session.commit()
        return b

    @classmethod
    def bulk_save(cls,
                  objects,
                  return_defaults=False,
                  update_changed_only=True):
        b = db.session.bulk_save_objects(
            objects, return_defaults=False, update_changed_only=True)
        db.session.commit()
        return b

    def get_choice_display(self, column, choice):
        if not hasattr(self, column):
            raise ValueError("%s object have no column %s" %
                             (self.__class__.__name__, column))
        if not hasattr(self, choice):
            raise ValueError("%s object have no choice %s" %
                             (self.__class__.__name__, choice))
        choice = dict(getattr(self, choice))
        value = getattr(self, column)
        return choice.get(value, value)

    @classmethod
    def get_one(cls, **filter_dict):
        return cls.query.filter_by(**filter_dict).one()

    @classmethod
    def get(cls, **filter_dict):
        instance = cls.query.filter_by(**filter_dict).first()
        # if not instance:
        #     setattr(cls, 'DoesNotExist', ObjectDoesNotExist)
        #     raise cls.DoesNotExist(cls)
        return instance

    @classmethod
    def get_list(cls,
                 page=1,
                 number=20,
                 filter_dict=dict(),
                 sort_tuple=tuple()):
        if not sort_tuple:
            order_by = None
            if hasattr(cls, '__mapper_args__'):
                order_by = getattr(cls, '__mapper_args__').get('order_by')
            if order_by is not None:
                sort_tuple = (order_by, )
            else:
                sort_tuple = ('id', )
        return cls.query.filter_by(
            **filter_dict).order_by(*sort_tuple).paginate(page, number, True)


class ModelTimeMixin(ModelMixin):
    @declared_attr
    def created_at(cls):
        return db.Column(db.DateTime, default=datetime.utcnow())

    @declared_attr
    def updated_at(cls):
        return db.Column(
            db.DateTime, default=datetime.utcnow(), onupdate=datetime.utcnow())


class ModelUserMixin(ModelTimeMixin):
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
            'User',
            backref=db.backref(
                name, cascade='all,delete', lazy='dynamic'),
            uselist=False,
            lazy='joined')
