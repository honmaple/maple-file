#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: upload.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-04-21 21:29:31 (CST)
# Last Update:星期日 2017-5-21 14:35:11 (CST)
#          By:
# Description:
# **************************************************************************
import click
import requests
import os

DEFAULT_HOST = 'http://127.0.0.1:8000'
DEFAULT_KEY = ''


@click.group()
def cli():
    pass


@cli.command()
@click.option('--host', '-h', default=DEFAULT_HOST)
@click.option('--key', '-k', default=DEFAULT_KEY)
@click.option('--pk', '-i')
def delete(host, key, pk):
    url = '{}/api/images/{}'.format(host, pk)
    headers = {
        'Api-Key': key,
        'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36'
    }
    r = requests.delete(url, headers=headers)
    print(r.text)


@cli.command()
@click.option('--host', '-h', default=DEFAULT_HOST)
@click.option('--username', '-u', prompt=True, help='upload files')
@click.password_option()
def login(host, username, password):
    url = host + '/api/login'
    data = {'username': username, 'password': password}
    r = requests.post(url, data=data)
    print(r.text)


@cli.command()
@click.option('--host', '-h', default=DEFAULT_HOST)
@click.option('--key', '-k', default=DEFAULT_KEY)
@click.option('--files', '-f', multiple=True)
def upload(host, key, files):
    url = host + '/api/images'
    multiple_files = []
    for f in files:
        i = ('images', (os.path.basename(f), open(f, 'rb'), 'image/png'))
        multiple_files.append(i)

    headers = {
        'Api-Key': key,
        'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36'
    }
    r = requests.post(url, files=multiple_files, headers=headers)
    print(r.text)


if __name__ == '__main__':
    cli()
