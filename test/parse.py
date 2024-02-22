#!/usr/bin/env python3

import re
import csv

logfile = "/Users/account/git_repo/Android/ARTTI_instrument/test/logs/element/current.log"
outfile = "/Users/account/git_repo/Android/ARTTI_instrument/test/logs/element/current.csv"

send_msg = re.compile(r"\[BM\] onSendMessage: (\d+) ms")
add_chunk = re.compile(r"\[BM\] add chunk: (\d+) ms")
render = re.compile(r"\[BM\] render: (\d+) ms")

def parse_log(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    msg = {
        "send" : None,
        "add": None,
        "render": None
    }
    out = []

    for line in lines:
        #match = send_msg.match(line)
        match = re.search(r"\[BM\] onSendMessage: (\d+) ms", line)
        if match:
            ms = int(match.group(1))
            if msg["send"]:
                out.append(msg)
            msg = {
                "send" : ms,
                "add": None,
                "render": None
            }
            continue

        match = add_chunk.search(line)
        if match:
            if msg["send"]:
                ms = int(match.group(1))
                msg["add"] = ms
            else:
                continue
    
        match = render.search(line)
        if match:
            if msg["add"]:
                ms = int(match.group(1))
                msg["render"] = ms
                out.append(msg)
                msg = {
                    "send" : None,
                    "add": None,
                    "render": None
                }
            else:
                continue 

    if msg["render"]:
        out.append(msg)

    return out

out = parse_log(logfile)
headers = list(out[0].keys())

with open(outfile, 'w', newline='') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=headers)
    writer.writeheader()
    
    for row in out:
        writer.writerow(row)

print("done")
