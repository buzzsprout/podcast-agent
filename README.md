


Podcast Agents
=========

This is library is for identifying entities that download or stream podcast episodes. For lack of a better term, these will be referred to as **Podcast Agents**. Podcast Agents include apps, bots, and browsers.

## Identification

In order to identify a Podcast Agent, we will be using the **user-agent** and/or **referrer**.  The code will attempt to match the podcast agent by comparing the user-agent before attempting to match the referrer. This information will be compared to a database of Podcast Agents and will result in one and only one match.

**Name**:  Name of the Podcast Agent that matches the database

**Browser**: Browser as parsed by [UserAgent GEM](https://github.com/gshutler/useragent)

**Platform**: Platform as parsed by [UserAgent GEM](https://github.com/gshutler/useragent)

## Installation

    gem install podcast-agent

### Examples
#### Stitcher on Safari

```ruby
user_agent_string = 'Mozilla/5.0 (iPad; CPU OS 12_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Pandora/1908.1'
referrer = 'https://app.stitcher.com/'
podcast_agent = PodcastAgentParser.find_by(user_agent_string: user_agent_string,
                                     referrer: referrer)
podcast_agent.name
# => 'Stitcher'
podcast_agent.browser
# => 'Safari'
podcast_agent.platform
# => 'iPad'
```

#### Pandora on Safari

```ruby
user_agent_string = 'Mozilla/5.0 (iPad; CPU OS 12_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Pandora/1908.1'
podcast_agent = PodcastAgentParser.find_by(user_agent_string: user_agent_string)
podcast_agent.name
# => 'Pandora'
podcast_agent.browser
# => 'Safari'
podcast_agent.platform
# => 'iPad'
```
#### Apple Home Pod

```ruby
user_agent_string = 'AppleCoreMedia/1.0.0.15C4092b (HomePod; U; CPU OS 11_2 like Mac OS X; de_de)'
podcast_agent = PodcastAgentParser.find_by(user_agent_string: user_agent_string)
podcast_agent.name
# => 'Apple HomePod'
podcast_agent.browser
# => 'AppleCoreMedia'
podcast_agent.platform
# => 'HomePod'
```
