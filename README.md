Podcast Agents
=========

This is library is for identifying entities that download or stream podcast episodes. For lack of a better term, these will be referred to as **Podcast Agents**. Podcast Agents include apps, bots, and devices.

## Identification

In order to identify a Podcast Agent, we will be using two pieces of information. The **user-agent** that requested the podcast episode as well as the referring URL or **referrer**. This information will be compared to a database of Podcast Agents and will result in one and only one match.