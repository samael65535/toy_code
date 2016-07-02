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
    def __init__(self, user_id, tweet_text, tweet_id):
        # initialize your data structure here.
        self.user_id = user_id
        self.tweet_text = tweet_text
        self.tweet_id = tweet_id
        pass
    @classmethod
    def create(cls, user_id, tweet_text, tweet_id):
        return Tweet(user_id=user_id, tweet_text=tweet_text, tweet_id=tweet_id)
class MiniTwitter:
    tweet_data = {}
    all_tweets = []
    cur_tweet_id = 0
    def __init__(self):
        # initialize your data structure here.
        pass

    # @param {int} user_id
    # @param {str} tweet
    # @return {Tweet} a tweet

    def postTweet(self, user_id, tweet_text):
        self.cur_tweet_id += 1
        tweet = Tweet(user_id, tweet_text, self.cur_tweet_id)
        if self.tweet_data.get(user_id) == None:
            data = {}
            data["follow"] = []
            data["tweets"] = []
            self.tweet_data[user_id] = data
        self.tweet_data[user_id]["tweets"].append(tweet.tweet_id)
        self.all_tweets.append(tweet)
        return tweet


    # @param {int} user_id
    # return {Tweet[]} 10 new feeds recently
    # and sort by timeline
    def getNewsFeed(self, user_id):
        pass


    # @param {int} user_id
    # return {Tweet[]} 10 new posts recently
    # and sort by timeline
    def getTimeline(self, user_id):
        arr = self.tweet_data[user_id]['tweets'][-10:][::-1]
        print(arr)
        ret = []
        for t in arr:
            ret.append(t)
        return ret


    # @param {int} from user_id
    # @param {int} to_user_id
    # from user_id follows to_user_id
    def follow(self, from_user_id, to_user_id):
        pass


    # @param {int} from user_id
    # @param {int} to_user_id
    # from user_id unfollows to_user_id
    def unfollow(self, from_user_id, to_user_id):
        pass


if __name__ == "__main__":
    mt = MiniTwitter()

    print(mt.getTimeline(1))
