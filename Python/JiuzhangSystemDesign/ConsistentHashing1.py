class Solution:
    # @param {int} n a positive integer
    # @return {int[][]} n x 3 matrix
    def consistentHashing(self, n):
        totalCount = 360
        ret = [[0, totalCount - 1, 1]]
        for j in range(1, n):
            maxCount = 0
            maxIdx = 0
            for i, m in enumerate(ret):
                count = m[1] - m[0] + 1
                if maxCount < count:
                    maxCount = count
                    maxIdx = i
            d = (ret[maxIdx][0] + ret[maxIdx][1]) / 2
            newMachine = [d + 1, ret[maxIdx][1], j + 1]
            ret[maxIdx][1] = d
            ret.append(newMachine)
        ret.sort(cmp=lambda x, y: cmp(x[1], y[1]))
        return ret

if __name__ == "__main__":
    s = Solution()
    print s.consistentHashing(360)