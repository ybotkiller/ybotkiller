from auth import Auth


class UserInfo(object):
    def __init__(self, id, name):
        self.user_id = id
        self.user_name = name

    def get_channels(self):
        pass
