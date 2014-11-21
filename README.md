Notify
======

You have an application that needs to talk to your users. Rendering emails and sending push notifications isn't the problem, but managing that data gets really messy.

Notify cleans all that up, and lets you focus on what notifications you send and the what they say.

![Travis CI](https://travis-ci.org/amoslanka/notify.svg)
[![Circle CI](https://circleci.com/gh/amoslanka/notify/tree/master.png?style=badge)](https://circleci.com/gh/amoslanka/notify/tree/master)
---

Notify is a Rails Engine that seeks manages the data structure of your notification system and gives you a way to define what notifications you send and some rules about how or when they're sent. It doesn't deal with the views, delivery, or logic that says when to send them. Just the defined notification definitions and the data that links your users with things they're notified about.

In the past when I've built notification systems, the meta information that that system must include can get ugly and complex real fast. The goal of this engine is to keep all that out of sight, but still accessible. Meanwhile your app should only have to declare notification definitions and say when to send them.

---

### Setup

First declare the gem

```ruby
gem 'notify-engine'
```

and install:

```
bundle install
rake db:migrate
```

Second, declare some notifications types. Use the generator to create one, or copy and paste some simple code into your app's `app/notifications` directory.

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

...

Though its simple up front but there's a lot more to it.



