# An analogue of the lab1 for verification
a = int(input())
b = int(input())
c = int(input())
d = int(input())

if ((a * c) != (b - d)) or (a > d):
    print(a - b * (c + d))
else:
    if ((b - c) > (a + d)) and (a < b):
        print(b * b - d + c)
    else:
        print(2 * c + 3 * d - 5)
