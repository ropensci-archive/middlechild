import mitmproxy

from mitmproxy import connections  # noqa
from mitmproxy import version
from mitmproxy import ctx
from mitmproxy.utils import strutils
from mitmproxy.net.http import cookies

def load(l):
    l.add_option(
        "warcdump", str, "", "WARC dump path.",
    )

def response(flow):
    mitmproxy.ctx.log.info("GOT %s " % flow.request.url)

def done():
    mitmproxy.ctx.log.info("DONE")
