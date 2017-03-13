#!/usr/bin/env python
# -*- coding: utf-8 -*-
# **************************************************************************
# Copyright © 2017 jianglin
# File Name: helps.py
# Author: jianglin
# Email: xiyang0807@gmail.com
# Created: 2017-03-13 13:05:02 (CST)
# Last Update:星期一 2017-3-13 13:6:30 (CST)
#          By:
# Description:
# **************************************************************************
from queue import Queue
from threading import Thread


class ThreadPool(object):
    '''线程池实现'''

    def __init__(self, num):
        self.num = num
        self.queue = Queue()
        self.threads = []

    def wait(self):
        self.queue.join()

    def get_thread(self):
        return self.queue.get()

    def add_thread(self, target, args=()):
        self.queue.put((target, args))

    def create_thread(self):
        for t in range(self.num):
            self.threads.append(ImageThread(self.queue))


class ImageThread(Thread):
    def __init__(self, queue):
        Thread.__init__(self)
        self.queue = queue
        self.setDaemon(True)
        self.start()

    def run(self):
        while not self.queue.empty():
            call, args = self.queue.get(timeout=2)
            url, deep = args
            call(*args)
            self.queue.task_done()
