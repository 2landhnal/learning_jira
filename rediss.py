import redis

r = redis.Redis(host='localhost', port=6380, decode_responses=True)

r.set('foo', 'bar')
foo = r.get('foo')

print(f"Value of 'foo': {foo}")