import base64
import secrets
import sys

if len(sys.argv) > 1:
    num_bytes = sys.argv[1]
else:
    num_bytes = 12

rand = secrets.SystemRandom()
print(base64.b64encode(rand.randbytes(num_bytes)).decode('ascii'))
