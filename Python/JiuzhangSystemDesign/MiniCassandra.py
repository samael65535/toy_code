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
            self.data[raw_key] = {}
        self.data[raw_key][column_key] = column_value

    # @param {string} raw_key a string
    # @param {int} column_start an integer
    # @param {int} column_end an integer
    # @return {Column[]} a list of Columns
    def query(self, raw_key, column_start, column_end):
        ret = []
        items = self.data.get(raw_key, {})
        items = sorted(items.items(), cmp=lambda x, y: cmp(x[0], y[0]))
        for col, val in items:
            if column_end >= col >= column_start:
                ret.append("(" + str(col) + ', "' + str(val) + '")')
        return ret


if __name__ == "__main__":
    m = MiniCassandra()
    m.insert("Linkedin", 7, "DGFINL")
    m.query("Apple", 7, 8)
    m.insert("Airbnb", 8, "BOKAQP")
    m.insert("Linkedin", 3, "ODAMGH")
    m.insert("Linkedin", 3, "KELFJN")
    m.insert("Facebook", 2, "HJPQEG")
    m.insert("Airbnb", 0, "OFACBI")
    m.query("Linkedin", 0, 1)
    m.insert("Facebook", 6, "QHPMCI")
    m.insert("Facebook", 6, "KOPBFL")
    m.insert("Linkedin", 4, "EAKNIF")
    m.query("Facebook", 0, 1)
    m.insert("Google", 3, "GNQCEK")
    m.insert("Facebook", 5, "NBEJIQ")
    m.insert("Linkedin", 8, "NOMCAD")
    m.insert("Airbnb", 1, "DPHKNG")
    m.query("Linkedin", 2, 7)
    m.query("Google", 4, 4)
    m.query("Facebook", 2, 2)
    m.query("Facebook", 2, 4)
    m.query("Linkedin", 3, 7)
    m.query("Linkedin", 0, 8)
    m.insert("Apple", 3, "PKJNHF")
    m.insert("Facebook", 3, "OMIJPQ")
