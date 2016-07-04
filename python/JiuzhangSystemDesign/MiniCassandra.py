"""
Definition of Column:
class Column:
    def __init__(self, key, value):
        self.key = key
        self.value = value
"""


class MiniCassandra:
    def __init__(self):
        # initialize your data structure here.
        self.data = {}

    # @param {string} raw_key a string
    # @param {int} column_key an integer
    # @param {string} column_value a string
    # @return nothing
    def insert(self, raw_key, column_key, column_value):
        d = self.data.get(raw_key)
        if d is None:
            self.data[raw_key] = []
        self.data[raw_key].append((column_key, column_value))
        self.data[raw_key].sort(cmp=lambda x, y: cmp(x[1], y[1]))

    # @param {string} raw_key a string
    # @param {int} column_start an integer
    # @param {int} column_end an integer
    # @return {Column[]} a list of Columns
    def query(self, raw_key, column_start, column_end):
        ret = []
        for item in self.data[raw_key]:
            col, val = item
            if col > column_end:
                return ret
            if column_end >= col >= column_start:
                ret.append((col, val))
        return ret


if __name__ == "__main__":
    m = MiniCassandra()
    m.insert("google", 1, "haha")
    results =  m.query("google", 0, 1)
    print "[%s]" % ','.join(['%s' % item for item in results])
