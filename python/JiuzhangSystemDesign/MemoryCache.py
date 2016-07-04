class Memcache:
    def __init__(self):
        # initialize your data structure here.
        self.cache = {}
        return

    # @param {int} curtTime an integer
    # @param {int} key an integer
    # @return an integer
    def get(self, curtTime, key):
        data = self.cache.get(key)
        if data == None:
            return 2147483647
        if data['expire'] >= curtTime or data['expire'] == -1:
            return data['val']
        return 2147483647


    # @param {int} curtTime an integer
    # @param {int} key an integer
    # @param {int} value an integer
    # @param {int} ttl an integer
    # @return nothing
    def set(self, curtTime, key, value, ttl):
        expire = curtTime + ttl - 1
        if ttl == 0:
            expire = -1
        data = {'val':value, 'expire': expire}
        self.cache[key] = data


    # @param {int} curtTime an integer
    # @param {int} key an integer
    # @return nothing
    def delete(self, curtTime, key):
        del self.cache[key]


    # @param {int} curtTime an integer
    # @param {int} key an integer
    # @param {int} delta an integer
    # @return an integer
    def incr(self, curtTime, key, delta):
        data = self.cache.get(key, 2147483647)
        if self.get(curtTime, key) == 2147483647:
            return 2147483647
        data['val'] += delta
        return data['val']


    # @param {int} curtTime an integer
    # @param {int} key an integer
    # @param {int} delta an integer
    # @return an integer
    def decr(self, curtTime, key, delta):
        data = self.cache.get(key, 2147483647)
        if self.get(curtTime, key) == 2147483647:
            return 2147483647
        data['val'] -= delta
        return data['val']


if __name__ == "__main__":
    m = Memcache()
    print m.get(1, 0)
    m.set(2, 1, 1, 2)
    print m.get(3, 1)
    print m.get(4, 1)
    print m.incr(5, 1, 1)
    m.set(6, 1, 3, 0)
    print m.incr(7, 1, 1)
    print m.decr(8, 1, 1)
    print m.get(9, 1)
    m.delete(10, 1)
    print m.get(11, 1)
    print m.incr(12, 1, 1)
