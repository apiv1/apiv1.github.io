def calc_point(nums, target):
    def eq(a, b):
        return abs(a - b) < 0.000000001
    def swap(nums, i, j):
        if i != j:
            tmp = nums[i]
            nums[i] = nums[j]
            nums[j] = tmp
    def cmp(item1, item2):
        a = item1[0]
        b = item2[0]
        if a == b:
            ops = [None, '+', '-', '*', '/']
            a = ops.index(item1[1])
            b = ops.index(item2[1])
            if a == b:
                if a == 0:
                    return 0
                return cmp(item1[2], item2[2])
        return -1 if a < b else 1
    def _point(nums, start = 0):
        results = []
        if start == len(nums) - 1:
            result = nums[-1]
            if eq(result[0], target):
                results.append(result)
            return results
        for n in range(start, len(nums)):
            swap(nums, start, n)
            for i in range(n+1, len(nums)):
                a,b = nums[start],nums[i]
                n1, n2 = (a,b) if cmp(a, b) < 0 else (b, a)

                nums[i] = (n1[0] + n2[0], '+', n1, n2)
                results += _point(nums, start + 1)

                nums[i] = (n1[0] - n2[0], '-', n1, n2)
                results += _point(nums, start + 1)

                nums[i] = (n1[0] * n2[0], '*', n1, n2)
                results += _point(nums, start + 1)

                if n2[0] != 0:
                    nums[i] = (n1[0] / n2[0], '/', n1, n2)
                    results += _point(nums, start + 1)

                if n1[0] != n2[0]:
                    nums[i] = (n2[0] - n1[0], '-', n2, n1)
                    results += _point(nums, start + 1)
                    if n1[0] != 0:
                        nums[i] = (n2[0] / n1[0], '/', n2, n1)
                        results += _point(nums, start + 1)

                nums[i] = b
            swap(nums, start, n)
        return results
    return _point(list(map(lambda x: (x, None), nums)))

def display(item):
    if not item[1]:
        return str(item[0]) if item[0] >= 0 else '(' + str(item[0]) + ')'

    op = item[1]
    a,b = item[2],item[3]
    op_a,op_b = a[1],b[1]
    d_a,d_b = display(a),display(b)

    if op == '*' or op == '/':
        if op_a == '+' or op_a == '-':
            d_a = '(' + d_a + ')'
        if op == '/' and op_b != None or op_b == '+' or op_b == '-':
            d_b = '(' + d_b + ')'
    elif op == '-':
        if op_b == '+' or op_b == '-':
            d_b = '(' + d_b + ')'
    return '%s %s %s'%(d_a, op, d_b)
import sys

def main():
    if len(sys.argv) < 3:
        print('usage: python ' + sys.argv[0] +' 24 1 2 3 4')
        return
    results = calc_point(list(map(lambda x: int(x), sys.argv[2:])), int(sys.argv[1]))
    if len(results) > 0:
        s = set()
        for result in results:
            d = display(result)
            if not d in s:
                s.add(d)
                print(d)
        print('Total: ' + str(len(s))) if len(s) > 0 else None
    else:
        print('None')

if __name__ == '__main__':
    main()
