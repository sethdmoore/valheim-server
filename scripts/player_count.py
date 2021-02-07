#!/usr/bin/env python3

import a2s
import os

def main():
    query_port = os.environ.get("QUERY_PORT", "2457")
    try:
        port = int(query_port)
    except Exception as e:
        raise ValueError("QUERY_PORT must be set to an integer! Was {0}\n{1}"
                         .format(query_port, e))

    addr = ('127.0.0.1', port)

    try:
       query = a2s.info(addr)
    except Exception:
        raise

    print(query.player_count)


if __name__ == '__main__':
    main()
