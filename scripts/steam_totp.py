#!/usr/bin/env python3
"""Generate Steam Guard TOTP code from shared secret."""
import hmac
import hashlib
import struct
import base64
import time
import sys

STEAM_CHARS = '23456789BCDFGHJKMNPQRTVWXY'

def get_steam_guard_code(shared_secret: str) -> str:
    key = base64.b64decode(shared_secret)
    t = int(time.time()) // 30
    msg = struct.pack('>Q', t)
    mac = hmac.new(key, msg, hashlib.sha1).digest()
    offset = mac[-1] & 0xF
    code_int = struct.unpack('>I', mac[offset:offset + 4])[0] & 0x7FFFFFFF
    code = ''
    for _ in range(5):
        code += STEAM_CHARS[code_int % len(STEAM_CHARS)]
        code_int //= len(STEAM_CHARS)
    return code


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('Usage: steam_totp.py <shared_secret>', file=sys.stderr)
        sys.exit(1)
    print(get_steam_guard_code(sys.argv[1]))
