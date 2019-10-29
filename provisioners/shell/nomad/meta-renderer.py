# -*- coding: utf-8 -*-
'''
Render meta string to nomad client meta block.
'''

import sys
import argparse
import textwrap

def parse_args():
    '''
    Parse command line args. Return meta string and indent.
    '''
    parser = argparse.ArgumentParser(description='Render nomad client meta block with passed in meta string.')
    parser.add_argument('meta', help='Meta string.')
    parser.add_argument('indent', type=int, default=0, help='Indent.')
    
    args = parser.parse_args()
    return args.meta, args.indent

def parse_meta_string(meta_string):
    '''
    Parse meta string to k/v dict
    '''
    return dict(x.split('=') for x in meta_string.split(','))

def render(meta_dict, indent):
    '''
    Render nomad client meta block. See
    https://www.nomadproject.io/docs/configuration/client.html#meta
    '''
    brace_indent = indent * ' '
    meta_indent = (indent + 2) * ' '

    print(textwrap.indent('meta {', brace_indent))
    for key, value in meta_dict.items():
        meta = "\"{}\" = \"{}\"".format(key, value)
        print(textwrap.indent(meta, meta_indent))
    print(textwrap.indent('}', brace_indent))

def exit(status=0, message=None):
    if message:
        print >>sys.stderr, message
    sys.exit(status)

def execute():
    meta_string, indent = parse_args()
    if not meta_string:
        exit()

    meta_dict = parse_meta_string(meta_string)
    render(meta_dict, indent)

if __name__ == "__main__":
    execute()
