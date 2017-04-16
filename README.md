# Project 3 - Twitter lite

Twitter lite is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

Time spent: 20 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:

- [x] Added App Icon.
- [x] Sign up link.
- [x] Float in image animation.
- [x] Custom pull to reload with animation with reusable code in seperate file.
- [x] Time intervals of minutes hours or day depending on how recent it is. (NSDateTimeAgo library)
- [x] Custom sized popover for creating new tweet.
- [x] UIAlert if there is a callback error.
- [x] Cleaned code with swiftLint. (ignored a few rules)
- [x] Async image loading with fade in. (I really enjoyed this from "flicks")
- [x] Phone says TWEET TWEET when re-tweeting. (AVFoundation see line 71 of composeTweetViewController)

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Utilizing enums.
2. Optimizing use of swiftLint

## Video Walkthrough

Here's a walkthrough of implemented user stories:

[![twitterFinal.gif](https://s27.postimg.org/l9essarb7/twitter_Final.gif)](https://postimg.org/image/hd1gwb6bj/)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

Trouble setting up swiftLint.
Bit of a learning curb in business logic as I have never used twitter before.

credit to icons8, afnetworking nsdateminimaltimeago, svprogresshud, bdboauth1manager

## License

    Copyright [2017] [Brandon aubrey]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


