#/usr/env python3
import sys


if __name__ == '__main__':
    try:
        file_name = sys.argv[1]
    except IndexError:
        sys.stderr.write('usage: ./swap.py filename [swapに使う文字列]')
        sys.exit(1)

    try:
        swap_str = sys.argv[2]
    except IndexError:
        swap_str = '__swap_tmp__'

    f = open(file_name)
    src = f.read()
    f.close()

    src = src.replace('>', swap_str)
    src = src.replace('<', '>')
    src = src.replace(swap_str, '<')

    f = open(file_name+'.rbf', 'w')
    f.write(src)
    f.close()
