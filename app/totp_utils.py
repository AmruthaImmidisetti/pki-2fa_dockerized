import base64
import pyotp
import time

def hex_to_base32(hex_seed: str) -> str:
    b = bytes.fromhex(hex_seed)
    return base64.b32encode(b).decode('utf-8')

def generate_totp_code(hex_seed: str) -> (str, int):
    base32_seed = hex_to_base32(hex_seed)
    totp = pyotp.TOTP(base32_seed, digits=6, interval=30)
    code = totp.now()
    # compute seconds remaining in current period
    period = 30
    valid_for = period - (int(time.time()) % period)
    return code, valid_for

def verify_totp_code(hex_seed: str, code: str, valid_window: int = 1) -> bool:
    base32_seed = hex_to_base32(hex_seed)
    totp = pyotp.TOTP(base32_seed, digits=6, interval=30)
    return totp.verify(code, valid_window=valid_window)
