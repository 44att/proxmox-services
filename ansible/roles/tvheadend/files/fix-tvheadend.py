import sys
import fileinput

for line in fileinput.input('/opt/tvheadend/src/webui/webui.c', inplace=True):
    if line.strip().startswith('ptimeout = '):
        line = '  ptimeout = 120;\n'
    sys.stdout.write(line)
