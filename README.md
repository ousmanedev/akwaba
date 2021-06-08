# Akwaba
Lightweight commenting platform using Notion as a backend

[Demo page with comments](https://akwabademo.herokuapp.com) - [Demo Notion database](https://www.notion.so/20a56f94db8d4ba59d94a82bd7b9129e?v=edcdfaaaec3a4f80b52715f2a3c95d59)

## Summary
Akwaba is a self hosted solution that you can embed in your website, and have your visitors add comments.

It uses Notion databases to store and retrieve all the data, vie Notion API. No need to configure and manage a Relational Database.

Akwaba acts like a bridge between your website, and your Notion database by essentially doing 2 things:
- Taking comments submitted by visitors on your website, and storing them in your Notion database
- Taking comments from your Notion database, and displaying them on your website for your visitors

From Notion, you can approve/disable a comment. You can take advantage of Notion powerful databases, and filter comments by page url, authors name, email.

Make sure to play with the demo and see the Notion demo database, and see how it works.

## Getting started
For using Akwaba, you first need to complete a few steps in Notion:
1. [Create an internal integration](https://developers.notion.com/docs#create-a-new-integration), and save your API token somewhere
2. [Duplicate this database in your Workspace](https://www.notion.so/4df5eeed271a4bdca0fbb1e7aefc7502?v=545227fcd2774907b0cd157fdea485e3), and save the ID of your new database somewhere
3. [Share your new database with your integration](https://developers.notion.com/docs#share-a-database-with-your-integration)

## Installation
The installation can be done in 3 steps:
- Hosting an instance of Akwaba
- Configuring the instance
- Embedding on your website

### Hosting an instance of Akwaba
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/ousmanedev/akwaba)

Akwaba is a web application, built with Ruby and [Sinatra](https://github.com/sinatra/sinatra). You can host an instance of Akwaba, on Heroku or any platform supporting [rack based](https://github.com/rack/rack) web applications.

Akwaba does not use a Database, or any third party addons to run. It's just the small web app.

### Configuring the instance
For Akwaba, to work properly, you need to set some environment variables:

- NOTION_TOKEN (required): Your notion integration API token
- HOST (required): The url of your Akwaba instance. If you've deployed it to Heroku, it will look like `https://yourappname.herokuapp.com`
- CLIENT_HOST (required): The url of the website, where you want to integrate Akwaba. Eg: https://myawesomeblog.com
- MODERATION_ON (optional): Set this variable to any value, if you want comments moderation. Remove it, to disable comments moderation.

### Embedding on your website
After hosting and configuring your Akwaba instance, you can now embed it in your website, so your visitors can add and see comments.

If your Akwaba instance is available at `akwaba.example.com` and your notion database ID is `123456789`, embed the following snipet, in your web pages where you want to show comments.

```js
<div id="akwaba"></div>
<script defer src="https://akwaba.example.com/akawaba.js" data-database-id="123456789"></script>
```

`Akwaba` expects to find an element with the ID `akwaba`, to load comments. You can specify another element, to contain the comments, by using the `data-container` attribute.

```js
<div id="my-comments"></div>
<script defer src="https://akwaba.example.com/akawaba.js" ata-database-id="123456789" data-container="#my-comments"></script>
```

## Usage
### Comments moderation
If you enable comments moderation on your website, you can enable/disable a comment from your Notion database.

- Use notion filters to find the comments, in your database
- Tick/Untick the checkbox in the column `is_approved`, to enable or disable a comment
- When reloading your web page, approved comments will show up