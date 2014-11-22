Notify
======

You have an application that needs to talk to your users. Rendering emails and sending push notifications isn't the problem, but managing that data gets really messy.

Notify cleans all that up, and lets you focus on what notifications you send and the what they say.

![Travis CI](https://travis-ci.org/amoslanka/notify.svg)
[![Circle CI](https://circleci.com/gh/amoslanka/notify/tree/master.png?style=badge)](https://circleci.com/gh/amoslanka/notify/tree/master)
---

Notify is a Rails Engine that seeks manages the data structure of your notification system and gives you a way to define what notifications you send and some rules about how or when they're sent. It doesn't deal with the views, delivery, or logic that says when to send them. Just the defined notification definitions and the data that links your users with things they're notified about.

In most notification systems built for rails applications, the meta information that that system must include can get ugly and complex real fast. The goal of this engine is to keep all that out of sight, but still accessible. Meanwhile your app should only have to declare notification definitions and say when to send them. All those extra rules and configurations are managed from a few single points of contact. The following features are configurable globally, per notification type, or per notification:

- **Send it anywhere**. Deliver notifications through as many platforms as you wish. Notify uses 'translators' as middlemen between its system and the code that carries out a delivery. Defining new translators for any kind of delivery platform is simple, and declaring which platform to deliver to is even easier. A translator for ActionMailer is provided and activated by default, so if email is your only platform, you're already done.
- [ROADMAPPED] **Visibility**. Declare whether a notification should be visible on a feed of notifications. Its common to allow your users to see a list of their notificiations. Notify provides well presented access to visible notifications making it easy to render them in your app.
- [ROADMAPPED] **Expirations**. Set an expiration date on a message to make it no longer visible or valid.
- [ROADMAPPED] **Retries**. Using external services can often result in unexpected failures due to outages on services you don't control. Retry the deliveries as many times as you like.
- [ROADMAPPED] **Policies**. A user usually has preferences on how and when they'd like to be contacted. Use policies to further determine if, when, and how your notifications are delivered to each user.
- [ROADMAPPED] **Async delivery**. Use built in biases towards doing the heavy work in a background queue.
- [ROADMAPPED] **Deliver later***. When using async delivery, we can also set notifications to be delivered at a specific date and time.
- [ROADMAPPED] **Bundled delivery**. Bundle multiple notifications into a single delivery, configurable per delivery platform.
- [ROADMAPPED] **Sticky**. A sticky notification will appear at the top of a notification list.
- [ROADMAPPED] **Throttle**. Limit the number of notifications that can go out per minute, hour, or day. Limits can be enforced by skipping additional messages or postponing each delivery until the throttle time limit is reached.

The above features are all configurable options when declaring or sending your notificaitons. Additionally, you have access to the following features:

- **Receipt flags**. Deliveries can be marked as received, so you know that the user has viewed the respective notification.
- [ROADMAPPED] **Deactivations**. Send a notification that automatically deactivates another when the former is received.
- **Send notifications to anything**. Since its your code that will be sending a notification off via your specified services, assign anything you want as the receiver of the notification.  [ROADMAPPED] You can even make something like a string a receiver. Sending a notification out on a pubsub channel? Set the channel name as the receiver.

---

Some keys to understanding what Notify does:

- Declaring a notification means creating a configuration that will be used whenever you later send a notification of this type.
- Notification declarations are stored in your `app/notifications` directory.
- Creating a notification means instantiating a notification that will be delivered to one or many receivers.
- Notify includes data models and migrations for notifications and deliveries.
- The notification model does not contain the actual text or message you'll be sending your users, but uses a polymorphic `activity` association in order to reference a model that does. Have regular announcements that are sent out on a regular basis? Create an announcements model and pass an instance when creating the notification.
- Rendering is all up to you. Whether you're delivering via email, push notification, or some other service, rendering the message is up to you. Notify provides patterns to follow for how to make this happen, especially since a notification should be rendered differently based on the service.
- A notification can have one or many receivers. Associating many receivers implies that the notification will be delivered to all receivers using the same ruleset as defined by the notification declaration and in the rules provided when creating the notification.
- The delivery model joins a notification with receivers. It also contains values specific per receiver and notification combination such as timestamps for when the notification was delivered to that receiver and when it was received.
- A translator is a class with an instance method called `deliver` that acts as a middleman between Notify and a specific delivery service. It translates information about the notification and receiver to conform to the protocol of the service code. For example, the built in ActionMailer translator takes the delivery and calls a mailer in the standard way that mailers are used.



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

Second, declare some notifications. Use the generator to create one, or copy and paste some simple code into your app's `app/notifications` directory.

```
rails generate notification foo
```

This creates a notification definition in `app/notifications` using the same name, and you should think of that name as the canonical name of this notification type.

```ruby
# app/notifications/foo_notification.rb

class WelcomeNotification
  extend Notify::NotificationType

  self.deliver_via = :action_mailer
  self.visible = true
end

```

And create a foo mailer to match it. Out of the box, Notify will delivery notifications by way of ActionMailer. If you don't override any configurations for your notification, Notify will try to use the mailer at N`otificationsMailer#foo`.

```ruby
# app/views/notifications_mailer/foo.html.erb

<h1> Hello foo! </h1>
```

All you have to do now is send a notification to your user.

```ruby
user = User.first
Notify.send :foo, to: user
```

Done and done.

---




