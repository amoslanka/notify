Notify
======

You have an application that needs to talk to your users. Rendering emails and sending push notifications isn't the problem, but managing that data gets really messy.

Notify cleans all that up, and lets you focus on what notifications you send and the what they say.

![](https://travis-ci.org/amoslanka/notify.svg)

---

Notify is a Rails Engine that seeks manages the data structure of your notification system and gives you a way to define what notifications you send and some rules about how or when they're sent. It doesn't deal with the views, delivery, or logic that says when to send them. Just the defined notification types and the data that links your users with things they're notified about.

In the past when I've built notification systems, the meta information that that system must include can get ugly and complex real fast. The goal of this engine is to keep all that out of site, but still accessible. Meanwhile your app should only have to declare notification types, hook into how they're rendered, and say when to send them.

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

This creates a notification in `app/notifications` using the same name, and you should think of that name as the canonical name of this notification type.

```ruby
# app/notifications/foo.rb

Notify.register_notification :foo do

  deliver_via :email
  retry 5
  visible true

end
```

And create a foo mailer to match it (delivery methods and how to find your mailers is super simple, but described later)

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



