import random

class Solution:
    machines = {}
    candi_micro_shard = []
    # @param {int} n a positive integer
    # @param {int} k a positive integer
    # @return {Solution} a Solution object
    @classmethod
    def create(cls, n, k):
        cls.n = n
        cls.k = k
        cls.candi_micro_shard = range(0, n)
        random.shuffle(cls.candi_micro_shard)
        return Solution()

    # @param {int} machine_id an integer
    # @return {int[]} a list of shard ids
    def addMachine(self, machine_id):
        count = min(self.k, self.n)
        ret = []
        for i in range(0, count):
            micro_shard = self.candi_micro_shard.pop()
            self.machines[micro_shard] = machine_id
            ret.append(micro_shard)

        return ret

    # @param {int} hashcode an integer
    # @return {int} a machine id
    def getMachineIdByHashCode(self, hashcode):
        while (True):
            if self.machines.get(hashcode) != None:
                return self.machines[hashcode]
            if (hashcode < self.n):
                hashcode += 1
            else:
                hashcode = 0



if __name__ == "__main__":
    s = Solution.create(100, 3)
    print s.addMachine(1)
    print s.getMachineIdByHashCode(4)
    print s.addMachine(2)
    print s.getMachineIdByHashCode(61)
    print s.getMachineIdByHashCode(91)