# Oven

Simple web app for plist files management.

## Intro

For iOS development, there're tons of useful libraries that fetches plist file online to remotely configure your apps.

To manage those plist files online for mobile developers can be a trouble, and in order to ease the burden, we created Oven for our in-house use but also open source for everyone else.

## Features

* Simple file browser and manager for S3
* Validation of plist format
* GitHub authentication

## Installation

Though it could be hosted in somewhere else, we recommended Heroku for Oven.

```
git clone git@github.com:polydice/oven.git
cd oven
heroku apps:create
git push heroku master
```

Then you need to configure Oven with S3/GitHub credentials.

The following environment variables are required for Oven:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
AWS_S3_BUCKET_NAME // The bucket name to put files

GITHUB_AUTHENTICATION_TEAM_ID // (Optional) Only user in this team can use the app
GITHUB_CLIENT_ID
GITHUB_CLIENT_SECRET
```

To set these variables, use:

```heroku config:set KEY1=VALUE1 [KEY2=VALUE2 …]```

## Cocoa Libraries

To name a few libraries that make use of remote plist files:

* [GroundControl](https://github.com/mattt/GroundControl)
* [iVersion](https://github.com/nicklockwood/iVersion)

## License

Oven is released under [MIT License](http://www.opensource.org/licenses/MIT)