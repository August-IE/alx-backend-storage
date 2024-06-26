#!/usr/bin/env python3
'''Log stats
'''
from pymongo import MongoClient


def print_nginx_request_logs(nginx_collection):
    '''Prints stats about Nginx request logs.
    '''
    total_logs = nginx_collection.count_documents({})
    print(f'{total_logs} logs')
    
    methods = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']
    for method in methods:
        req_count = nginx_collection.count_documents({'method': method})
        print(f'\tmethod {method}: {req_count}')

    status_checks_count = nginx_collection.count_documents({'method': 'GET', 'path': '/status'})
    print(f'{status_checks_count} status checks')


def run():
    '''Provides some stats about Nginx logs stored in MongoDB.
    '''
    client = MongoClient('mongodb://127.0.0.1:27017')
    nginx_logs = client.logs.nginx
    print_nginx_request_logs(nginx_logs)


if __name__ == '__main__':
    run()
