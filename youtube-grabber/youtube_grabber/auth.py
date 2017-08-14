import httplib2
import sys

from apiclient.discovery import build_from_document
from oauth2client.client import flow_from_clientsecrets
from oauth2client.file import Storage
from oauth2client.tools import run_flow


YOUTUBE_READ_WRITE_SSL_SCOPE = \
    "https://www.googleapis.com/auth/youtube.force-ssl"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

MISSING_CLIENT_SECRETS_MESSAGE = """
WARNING: Please configure OAuth 2.0

For more information about the client_secrets.json file format, please visit:
https://developers.google.com/api-client-library/python/guide/aaa_client_secrets
"""


class Auth(object):
    def __init__(self, client_secrets_file, discoverydocument):
        self.client_secrets_file = client_secrets_file
        self.discoverydocument = discoverydocument

    def get_authenticated_service(self, args):
        flow = flow_from_clientsecrets(self.client_secrets_file,
            scope=YOUTUBE_READ_WRITE_SSL_SCOPE,
            message=MISSING_CLIENT_SECRETS_MESSAGE)

        storage = Storage("%s-oauth2.json" % sys.argv[0])
        credentials = storage.get()

        if credentials is None or credentials.invalid:
            credentials = run_flow(flow, storage, args)

        with open(self.discoverydocument, "r") as f:
            doc = f.read()
            return build_from_document(doc,
                http=credentials.authorize(httplib2.Http()))
