#!/usr/bin/env python3
import argparse, ssl, sys, time, urllib.request

ap = argparse.ArgumentParser()
ap.add_argument("urls", nargs="+")
ap.add_argument("-t", "--timeout", type=int, default=5)
ap.add_argument("-r", "--retries", type=int, default=3)
ap.add_argument("--insecure", action="store_true")
args = ap.parse_args()

ctx = None
if args.insecure:
    ctx = ssl._create_unverified_context()

def check(url):
    for i in range(1, args.retries + 1):
        try:
            req = urllib.request.Request(url, method="GET")
            with urllib.request.urlopen(req, timeout=args.timeout, context=ctx) as resp:
                code = resp.getcode()
        except Exception:
            code = 0
        if 200 <= int(code) < 400:
            print(f"[OK] {url} -> {code}")
            return True
        else:
            print(f"[TRY {i}/{args.retries}] {url} -> {code}")
            time.sleep(1)
    print(f"[DOWN] {url} -> {code}")
    return False

all_ok = all(check(u) for u in args.urls)
sys.exit(0 if all_ok else 1)

