from aggregator import Aggregator
from comment_bucket import CommentBucket
from oauth2client.tools import argparser
import gauth
import json
from user_info import UserInfo
import re


argparser.add_argument("-s", "--client-secrets-file", dest="client_secrets_file",
    default="client_secrets.json", help="Path to client secrets")
argparser.add_argument("-d", "--discoverydocument", dest="discoverydocument",
    default="youtube-v3-discoverydocument.json", help="Discovery json")
argparser.add_argument("videoid", type=str, help="YouTube video id")
args = argparser.parse_args()

def main():
    auth = gauth.Auth(args.client_secrets_file, args.discoverydocument)
    youtube = auth.get_authenticated_service(args)
    aggregator = Aggregator(youtube, args.videoid)
    aggregator.aggregate()
    aggregator.get_csv()

if __name__ == "__main__":
    main()