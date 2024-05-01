#!/usr/bin/env python3
'''Document list
'''


def list_all(mongo_collection):
    '''A funcion that lists all documents in a collection.
    '''
    return [doc for doc in mongo_collection.find()]
