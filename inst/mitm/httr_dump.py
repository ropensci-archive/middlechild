import json
import os
import gzip
import base64

from datetime import datetime
from datetime import timezone

import mitmproxy

import typing

from mitmproxy import connections  # noqa
from mitmproxy import version
from mitmproxy import ctx
from mitmproxy.utils import strutils
from mitmproxy.net.http import cookies

class httr_dumper:

    def __init__(self):
      self.f = None

    def load(self, loader):
      loader.add_option(
        name = "httrdump",
        typespec = str,
        default = "dump.json",
        help = "path to dump httr-format log",
      )

    def configure(self, updated):
      self.f = gzip.open(ctx.options.httrdump, "wb")

    def response(self, flow):
      
      started_date_time = datetime.fromtimestamp(flow.request.timestamp_start, timezone.utc).strftime('%Y-%m-%d %H:%M:%S')

      entry = {
        "url": flow.request.url,
        "status_code": flow.response.status_code,
        "headers": {
          "content-type": flow.response.headers.get('Content-Type', 'text/html')
        },
        "content": base64.b64encode(flow.response.content).decode(),
        "date": started_date_time,
        "request": {
          "method": flow.request.method,
          "url": flow.request.url
        } 
      }

      httr_rec: str = json.dumps(entry, separators=(',', ':')) + "\n"
      httr_raw: bytes = httr_rec.encode()

      self.f.write(httr_raw)

    def done(self):
      self.f.close()

addons = [ httr_dumper() ]