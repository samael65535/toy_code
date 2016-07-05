'''
Definition of Tweet:
class Tweet:
    @classmethod
    def create(cls, user_id, tweet_text):
         # This will create a new tweet object,
         # and auto fill id
'''


class Tweet:
    user_id = 0
    tweet_text = ""

    def __init__(self, user_id, tweet_text):
        # initialize your data structure here.
        self.user_id = user_id
        self.tweet_text = tweet_text

    @classmethod
    def create(cls, user_id, tweet_text):
        return Tweet(user_id=user_id, tweet_text=tweet_text)


class MiniTwitter:
    tweet_data = {}
    all_tweets = []
    cur_tweet_id = -1

    def __init__(self):
        # initialize your data structure here.
        pass

    # @param {int} user_id
    # @param {str} tweet
    # @return {Tweet} a tweet

    def postTweet(self, user_id, tweet_text):
        self.cur_tweet_id += 1
        tweet = Tweet(user_id, tweet_text);
        tweet.tweet_id = self.cur_tweet_id
        if self.tweet_data.get(user_id) is None:
            data = {}
            data["follow"] = {}
            data["tweets"] = []
            self.tweet_data[user_id] = data
        self.tweet_data[user_id]["tweets"].append(self.cur_tweet_id)
        self.all_tweets.append(tweet)
        return tweet

    # @param {int} user_id
    # return {Tweet[]} 10 new feeds recently
    # and sort by timeline
    def getNewsFeed(self, user_id):
        if self.tweet_data.get(user_id) is None:
            data = {"tweets": [], "follow": {}}
            self.tweet_data[user_id] = data
        arr = self.tweet_data[user_id]['tweets'][-10:][::-1]
        ret = []
        for k, v in self.tweet_data[user_id]['follow'].items():
            if v is True and self.tweet_data.get(k) is not None:
                arr.extend(self.tweet_data[k]['tweets'][-10:][::-1])

        r = sorted(arr, reverse=True)[:10:]
        for t in r:
            ret.append(self.all_tweets[t])
        return ret

    # @param {int} user_id
    # return {Tweet[]} 10 new posts recently
    # and sort by timeline
    def getTimeline(self, user_id):
        if self.tweet_data.get(user_id) is None:
            data = {"tweets": [], "follow": {}}
            self.tweet_data[user_id] = data
        arr = self.tweet_data[user_id]['tweets'][-10:][::-1]
        ret = []
        for t in arr:
            ret.append(self.all_tweets[t])
        return ret

    # @param {int} from user_id
    # @param {int} to_user_id
    # from user_id follows to_user_id
    def follow(self, from_user_id, to_user_id):
        if self.tweet_data.get(from_user_id) is None:
            data = {"tweets": [], "follow": {}}
            self.tweet_data[from_user_id] = data
        self.tweet_data[from_user_id]["follow"][to_user_id] = True

    # @param {int} from user_id
    # @param {int} to_user_id
    # from user_id unfollows to_user_id
    def unfollow(self, from_user_id, to_user_id):
        if self.tweet_data.get(from_user_id) is None:
            data = {"tweets": [], "follow": {}}
            self.tweet_data[from_user_id] = data
        self.tweet_data[from_user_id]["follow"][to_user_id] = False


if __name__ == "__main__":
    mt = MiniTwitter()
    mt.getNewsFeed(3)
    mt.getNewsFeed(7)
    mt.follow(1, 2)
    mt.getTimeline(10)
    mt.follow(6, 5)
    mt.getTimeline(8)
    mt.getNewsFeed(5)
    mt.postTweet(1, "ode is b")
    mt.postTweet(1, "nlintcodelintcodelintcode i lo")
    mt.getTimeline(8)
    mt.postTweet(11, "lintcodelintco")
    mt.getNewsFeed(9)
    mt.getNewsFeed(11)
    mt.follow(10, 12)
    mt.postTweet(6, "tcode")
    mt.postTweet(5, "nlintcodelintcodelint")
    mt.follow(1, 6)
    mt.getNewsFeed(3)
    mt.getTimeline(6)
    mt.getNewsFeed(6)
    mt.follow(3, 8)
    mt.getNewsFeed(1)
    mt.postTweet(11, "iklmnlintcodelintcodelintcode i love l")
    mt.follow(6, 10)
    mt.getNewsFeed(2)
    mt.postTweet(5, "lintcode lintcode is bes")
    mt.postTweet(7, "efghiklmnlintcodelintcodelintcode")
    mt.getTimeline(4)
    mt.postTweet(3, "tcodelintcode i love lintcode l")
    mt.postTweet(7, "ntcodelintcodelintcode i love lintcod")
    mt.postTweet(11, "ghiklmnlint")
    mt.getTimeline(4)
    mt.postTweet(8, "intcodelintcodelintcode i love lintcode lintcode is ")
    mt.postTweet(1, "code is bes")
    mt.getTimeline(12)
    mt.postTweet(9, "ode lintc")
    mt.getNewsFeed(7)
    mt.unfollow(1, 6)
    mt.getTimeline(10)
    mt.follow(3, 9)
    mt.postTweet(2, "tcode i")
    mt.postTweet(5, "intcodel")
    mt.postTweet(9, "efghiklmnlintcodelintcodelintcode i lo")
    mt.postTweet(1, "ghiklmnlintcodelintcodelintcode i love lintcode lintcode ")
    mt.postTweet(8, "ntcode i love lintcode lin")
    mt.follow(10, 2)
    mt.postTweet(4, "iklmnlintc")
    mt.getTimeline(3)
    mt.postTweet(1, "de i love lintcode lintcode i")
    mt.follow(8, 4)
    mt.postTweet(9, "ghikl")
    mt.postTweet(11, "e lintcode")
    mt.getNewsFeed(5)
    mt.getNewsFeed(7)
    mt.postTweet(2, "od")
    mt.getTimeline(5)
    mt.postTweet(9, "klmnlintcodelintcodelin")
    mt.getNewsFeed(12)
    mt.postTweet(3, "elintcode i love lintcode")
    mt.getNewsFeed(4)
    mt.postTweet(4, "codelintcode i love lintco")
    mt.postTweet(1, "acbdefghiklmnlintcodelintcodelintcode i love lintcod")
    mt.follow(12, 3)
    mt.getTimeline(8)
    mt.getTimeline(4)
    mt.follow(4, 7)
    mt.getNewsFeed(4)
    mt.getNewsFeed(12)
    mt.follow(2, 5)
    mt.getTimeline(1)
    mt.postTweet(7, "mnlintcodelintcodelintcode i love lintcode")
    mt.getNewsFeed(2)
    mt.getTimeline(1)
    mt.getNewsFeed(12)
