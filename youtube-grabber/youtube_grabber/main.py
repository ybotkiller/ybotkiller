import json
from comment_bucket import CommentBucket


def main():
    cb = CommentBucket("SCtbHzU-KDY")
    cb.fetch_all_comments()
    cb.get_csv()

if __name__ == "__main__":
    main()
