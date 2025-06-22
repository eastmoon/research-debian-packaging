# Import library
import sys
from hashlib import shake_128

# Execute script
if __name__ == '__main__':
    result = bytearray()
    filename = sys.argv[1]
    digest_size = sys.argv[2]
    with open(filename, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b''):
            result += chunk
    code = shake_128(result).hexdigest(int(digest_size, base=10))
    print(code)
