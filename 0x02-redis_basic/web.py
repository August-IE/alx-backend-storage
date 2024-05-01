#!/usr/bin/env python3
'''A module with tools for request caching and tracking.
'''
import redis
import requests
from functools import wraps
from typing import Callable


redis_store = redis.Redis()
'''The module-level Redis instance.
'''


def data_cacher(method: Callable) -> Callable:
    '''Caches the output of fetched data.
    '''
    @wraps(method)
    def invoker(url: str) -> str:
        '''The wrapper function for caching the output.
        '''
        cache_key = f'result:{url}'
        count_key = f'count:{url}'

        redis_store.incr(count_key)
        result = redis_store.get(cache_key)

        if result:
            return result.decode('utf-8')

        result = method(url)

        redis_store.set(count_key, 0)
        redis_store.setex(cache_key, 10, result)

        return result

    return invoker


@data_cacher
def get_page(url: str) -> str:
    '''Returns the content of a URL after caching the request's response,
    and tracking the request.
    '''
    return requests.get(url).text
