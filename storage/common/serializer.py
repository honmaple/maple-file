#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2016 jianglin
# File Name: serializer.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2016-12-13 22:08:23 (CST)
# Last Update:星期一 2017-3-13 13:28:30 (CST)
#          By:
# Description:
# **************************************************************************
from sqlalchemy import inspect
from sqlalchemy.orm.interfaces import (ONETOMANY, MANYTOMANY)


class PageInfo(object):
    def __init__(self, paginate):
        self.paginate = paginate

    def as_dict(self):
        pageinfo = {
            'items': True,
            'pages': self.paginate.pages,
            'has_prev': self.paginate.has_prev,
            'page': self.paginate.page,
            'has_next': self.paginate.has_next,
            'iter_pages': list(
                self.paginate.iter_pages(
                    left_edge=1, left_current=2, right_current=3,
                    right_edge=1))
        }
        return pageinfo


class Field(object):
    def __init__(self, source, args={}, default=None):
        self.source = source
        self.args = args
        self.default = default

    def data(self, instance):
        if hasattr(instance, self.source):
            source = getattr(instance, self.source)
            if not callable(source):
                return source
            return source(**self.args)
        return self.default


class Serializer(object):
    def __init__(self,
                 instance,
                 many=False,
                 include=[],
                 exclude=[],
                 extra=[],
                 depth=2):
        self.instance = instance
        self.many = many
        self.depth = depth
        self.include = include
        self.exclude = exclude
        self.extra = extra

    @property
    def data(self):
        meta = self.Meta
        if not self.include and hasattr(meta, 'include'):
            self.include = meta.include
        if not self.exclude and hasattr(meta, 'exclude'):
            self.exclude = meta.exclude
        if not self.extra and hasattr(meta, 'extra'):
            self.extra = meta.extra
        # if not self.depth:
        #     self.depth = meta.depth if hasattr(meta, 'depth') else 2
        # if self.include and self.exclude:
        #     raise ValueError('include and exclude can\'t work together')
        if self.many:
            return self._serializerlist(self.instance, self.depth)
        return self._serializer(self.instance, self.depth)

    def _serializerlist(self, instances, depth):
        results = []
        for instance in instances:
            result = self._serializer(instance, depth)
            if result:
                results.append(result)
        return results

    def _serializer(self, instance, depth):
        result = {}
        if depth == 0:
            return result
        depth -= 1
        model_class = self.get_model_class(instance)
        inp = self.get_inspect(model_class)
        model_data = self._serializer_model(inp, instance, depth)
        relation_data = self._serializer_relation(inp, instance, depth)
        extra_data = self._serializer_extra(instance)
        result.update(model_data)
        result.update(relation_data)
        result.update(extra_data)
        return result

    def _serializer_extra(self, instance):
        extra = self.extra
        result = {}
        for e in extra:
            # extra_column = getattr(self, e)
            # if isinstance(extra_column, Field):
            #     result[e] = extra_column.data(instance)
            # else:
            extra_column = getattr(instance, e)
            result[e] = extra_column if not callable(
                extra_column) else extra_column()
        return result

    def _serializer_model(self, inp, instance, depth):
        result = {}
        model_columns = self.get_model_columns(inp)
        for column in model_columns:
            result[column] = getattr(instance, column)
        return result

    def _serializer_relation(self, inp, instance, depth):
        result = {}
        relation_columns = self.get_relation_columns(inp)
        for relation in relation_columns:
            column = relation.key
            serializer = Serializer
            if hasattr(self, column):
                serializer = getattr(self, column)
            if relation.direction in [ONETOMANY, MANYTOMANY
                                      ] and relation.uselist:
                children = getattr(instance, column)
                if relation.lazy == 'dynamic':
                    children = children.all()
                result[column] = serializer(
                    children,
                    many=True,
                    exclude=[relation.back_populates],
                    depth=depth).data if children else []
            else:
                child = getattr(instance, column)
                if relation.lazy == 'dynamic':
                    child = child.first()
                result[column] = serializer(
                    child,
                    many=False,
                    exclude=[relation.back_populates],
                    depth=depth).data if child else {}
        return result

    def get_model_class(self, instance):
        return getattr(instance, '__class__')

    def get_inspect(self, model_class):
        return inspect(model_class)

    def get_model_columns(self, inp):
        if self.include:
            model_columns = [
                column.name for column in inp.columns
                if column.name in self.include
            ]
        elif self.exclude:
            model_columns = [
                column.name for column in inp.columns
                if column.name not in self.exclude
            ]
        else:
            model_columns = [column.name for column in inp.columns]

        return model_columns

    def get_relation_columns(self, inp):
        if self.include:
            relation_columns = [
                relation for relation in inp.relationships
                if relation.key in self.include
            ]
        elif self.exclude:
            relation_columns = [
                relation for relation in inp.relationships
                if relation.key not in self.exclude
            ]
        else:
            relation_columns = [relation for relation in inp.relationships]
        return relation_columns

    class Meta:
        depth = 2
        include = []
        exclude = []
        extra = []
