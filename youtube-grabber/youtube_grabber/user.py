class User(object):
    def __init__(self, service, name, id):
        self.user_name = name
        self.channel_id = id
        self.service = service
        self.ui = dict()

    def _channels_list_by_username(self):
        # kwargs = remove_empty_kwargs(**kwargs)
        results = self.service.channels().list(
            part="snippet,contentDetails,statistics,status",
            forUsername=self.user_name).execute()

        return results

    def _channels_list_by_id(self):
        # kwargs = remove_empty_kwargs(**kwargs)
        results = self.service.channels().list(
            part="snippet,contentDetails,statistics,status",
            id=self.channel_id).execute()

        return results

    def get_basic_user_info(self):
        channels = self._channels_list_by_id()

        if len(channels["items"]) > 0:
            self.ui = channels["items"][0]["statistics"]
        else:
            self.ui = {u'commentCount': u'Undefined',
                       u'viewCount': u'Undefined',
                       u'videoCount': u'Undefined',
                       u'subscriberCount': u'Undefined',
                       u'hiddenSubscriberCount': "Undefined"}

        return self.ui
