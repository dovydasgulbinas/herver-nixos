#!/usr/bin/python3


import json, sys

har = json.load(open(sys.argv[1]))
for entry in har["log"]["entries"]:
    req = entry["request"]
    print(f"{req['method']} {req['url']}")
    for h in req["headers"]:
        print(f"{h['name']}: {h['value']}")
    if "postData" in req:
        print("\n" + req["postData"].get("text", ""))
    print("\n\n")
