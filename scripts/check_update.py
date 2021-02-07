#!/usr/bin/env python3
import requests
import json
import sys
import os

from pprint import pprint

STEAM_API='https://api.steamcmd.net/v1/info/{}'

def get_build_id(app_id, branch):
    """
    Query steamcmd.net for our app_id
    Return branch (public) build ID
    """
    response = {}
    try:
        r = requests.get(STEAM_API
                         .format(app_id))
    except Exception as e:
        print("Exception while checking for update: {}"
              .format(e), file=sys.stderr)
        raise

    try:
        response = r.json()
    except Exception as e:
        print("Exception while unmarshaling update response"
              " as json: {}".format(e), file=sys.stderr)
        raise

    # some mild defensive programming
    if 'data' not in response:
        raise ValueError('Missing expected key "data" from response')

    if app_id not in response['data']:
        raise ValueError('Missing expected key (app_id): {0}'
                         ' from response["data"]'.format(app_id))

    if 'depots' not in response['data'][app_id]:
        raise ValueError('Missing expected key: "depots" from '
                         'response["data"]["{0}"]'.format(app_id))

    if 'branches' not in response['data'][app_id]['depots']:
        raise ValueError('Missing expected key: "branches" from '
                         'response["data"]["{0}"]["depots"]'.format(app_id))

    if branch not in response['data'][app_id]['depots']['branches']:
        raise ValueError('Missing expected key: "{0}" from '
                         'response["data"]["{1}"]["depots"]["branches"]'
                         .format(branch, app_id), file=sys.stderr)

    if 'buildid' not in \
        response['data'][app_id]['depots']['branches']['public']:
        raise ValueError('Missing expected key: "buildid" from '
                         'response["data"]["{0}"]["depots"]["branches"]["{1}"]'
                         .format(app_id, branch), file=sys.stderr)


    # we only care about this
    return response['data'][app_id]['depots']['branches'][branch]['buildid']


def main():
    """
    Grab the latest build ID from steamcmd.net
    """
    app_id = os.environ.get('APP_ID', '896660')
    branch = os.environ.get('APP_BRANCH', 'public')

    try:
        build_id = get_build_id(app_id, branch)
    except Exception as e:
        print("Could not retrieve update status at this time: {}"
              .format(e), file=sys.stderr)
        sys.exit(2)

    print(build_id)


if __name__ == '__main__':
    main()
