Notify
======

You have an application that needs to talk to your users. Rendering emails and sending push notifications isn't the problem, but managing that data gets really messy.

Notify cleans all that up, and lets you focus on what notifications to send and what they say.

![Travis CI](https://travis-ci.org/amoslanka/notify.svg)
[![Circle CI](https://circleci.com/gh/amoslanka/notify/tree/master.png?style=badge)](https://circleci.com/gh/amoslanka/notify/tree/master)
---

Notify is a Rails Engine that seeks to manage the data structure of your notification system and gives you a way to define what notifications you send and some rules about how or when they're sent. It doesn't deal with the views, delivery, or logic that says when to send them. It provides notification strategy declarations and manages the data that links your users with things they're notified about.

In most notification systems built for rails applications, the meta information that that system must include can get ugly and complex real fast. The goal of this engine is to keep all that out of sight, but still accessible. Meanwhile your app should only have to declare notification strategies and say when to send them. All those extra rules and configurations are managed from a few single points of contact. The following features are configurable globally, per notification strategy, or per message:

- **Send it anywhere**. Deliver notifications through as many services as you wish. Defining new adapters for any kind of delivery service is simple, and declaring which service to deliver through is even easier. A adapter for ActionMailer is provided and activated by default, so if email is your only platform, you're already done.
- [ROADMAPPED] **Visibility**. Declare whether a notification should be visible on a feed of notifications. Its common to allow your users to see a list of their notificiations. Notify provides well presented access to visible notifications making it easy to render them in your app.
- [ROADMAPPED] **Expirations**. Set an expiration date on a message to make it no longer visible or valid.
- [ROADMAPPED] **Retries**. Using external services can often result in unexpected failures due to outages on services you don't control. Retry the deliveries as many times as you like.
- [ROADMAPPED] **Policies**. A user usually has preferences on how and when they'd like to be contacted. Use policies to further determine if, when, and how your notifications are delivered to each user.
- [ROADMAPPED] **Async delivery**. Use built in biases towards doing the heavy work in a background queue.
- [ROADMAPPED] **Deliver later***. When using async delivery, we can also set notifications to be delivered at a specific date and time.
- [ROADMAPPED] **Bundled delivery**. Bundle multiple notifications into a single delivery, configurable per delivery platform.
- [ROADMAPPED] **Sticky**. A sticky notification will appear at the top of a notification list.
- [ROADMAPPED] **Throttle**. Limit the number of notifications that can go out per minute, hour, or day. Limits can be enforced by skipping additional messages or postponing each delivery until the throttle time limit is reached.
- [ROADMAPPED] **Priority**. Mark a notification as more important relative to others.

The above features are all configurable options when declaring or sending your notificaitons. Additionally, you have access to the following features:

- **Receipt flags**. Deliveries can be marked as received, so you know that the user has viewed the respective notification.
- [ROADMAPPED] **Deactivations**. Send a notification that automatically deactivates another when the former is received.
- **Send notifications to anything**. Since its your code that will be sending a notification off via your specified services, assign anything you want as the receiver of the notification.  [ROADMAPPED] You can even make something like a string a receiver. Sending a notification out on a pubsub channel? Set the channel name as the receiver.

---

Some keys to understanding what Notify does:

- A notification strategy, or often just referred to as a notification, is a blueprint for messages that you will send out. The strategy refers to the set of rules and configurations that will be applied to the message, unless they are overridden when created.
- Notification strategies are stored in your `app/notifications` directory.
- Creating a notification means specifying a strategy and configurations to use, and letting Notify create the models it uses to connect your receivers with the message.
- Notify includes data models and migrations for messages and deliveries.
- The message model does not contain the actual text or message you'll be sending your users, but uses a polymorphic `activity` association in order to reference a model that does. Have regular announcements that are sent out on a regular basis? Create an announcements model and pass an instance when creating the notification.
- Rendering is all up to you. Whether you're delivering via email, push notification, or some other service, rendering the message is up to you. Notify provides patterns to follow for how to make this happen, especially since a message should be rendered differently based on the service.
- A message can have one or many receivers. Associating many receivers implies that the notification will be delivered to all receivers using the same ruleset as defined by the strategy used and in the rules provided when creating it.
- The delivery model joins a message with receivers. It also contains values specific per receiver and message combination such as timestamps for when the message was delivered to that receiver and when it was received.
- An adapter is a class with an instance method called `deliver` that acts as a middleman between Notify and a specific delivery service. It adapts information about the message and receiver to conform to the protocol of the service code. For example, the built in ActionMailer adapter takes the delivery and calls a mailer in the standard way that mailers are used.
- A ruleset is basically just a hash containing the configuration values for a specific notification.

---

### Setup

First, install the engine.

```
# Add to Gemfile
gem 'notify-engine'

# Then run
bundle install
rake db:migrate
```

Second, declare some notification strategies. Use the generator to create one, or copy and paste some simple code into your app's `app/notifications` directory.

```
rails generate notify:notification foo
```

This creates a notification definition in `app/notifications` using the same name, and you should think of that name as the canonical name of this strategy.

```ruby
# app/notifications/foo_notification.rb

class WelcomeNotification
  extend Notify::Notification

  self.deliver_via = :action_mailer
  self.visible = true
end

```

And create a foo mailer to match it. Out of the box, Notify will delivery messages by way of ActionMailer. If you don't override any configurations for your notification, Notify will try to use the mailer at N`otificationsMailer#foo`.

```ruby
# app/views/notifications_mailer/foo.html.erb

<h1> Hello foo! </h1>
```

All you have to do now is send a message to your user.

```ruby
user = User.first
Notify.send :foo, to: user
```

Done and done.

---

### More Detail

##### Global configuration

##### Generators

###### Notification

```
rails g notify:notification foo
```

Generates a notification strategy file in `app/notifications`. The name defined here is
then used when you create a notification using this configuration.

For example, if you generate a notification named "announcement", you would then
create an announcement notification by calling `Notify.create :announcement, to: User.all`

###### Adapter

```
rails g notify:adapter foo
```

Generates a adapter that will allow you to convert notification delivery data
into an action that sends the notification by way of the service it is built for.

For example, if your app sends out push notifications and you have a service object that
handles sending a message to a particular device token, generate a adapter named "push"
and edit the generated class's `deliver` method to retrieve the device token from the
delivery receiver, render the message of the notification, and send both to your service
object for delivery.

To automatically deliver a particular notification through your created "push"
adapter, add it to the declaration's `deliver_via` rule: `deliver_via << :push`.

##### Creating a notification strategy

##### Creating a notification

##### Helpers for your receiver classes

##### Deliver to multiple services by defining adapters

##### Retrieve a receiver's notifications

##### Mark messages as received by a receiver

##### Delivery failure and safety mechanisms

##### Use background queueing to carry out deliveries
