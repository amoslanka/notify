Notify Engine Roadmap
---------------------

_Not yet assigned to a release target, but ordered according to current priority:_

**Async delivery**. Easily allow processing and/or delivery to happen in a worker. Could perhaps include workers for specific queue engines, requiring the user to declare configure Notify to work with it. Possible to async both delivery creation and delivery execution?

**Global configuration**. Set global ruleset values and notify configurations from a global perspective.

**Spec helpers**. Easy to use spec matchers to make testing easier.

**Deliver later***. When using async delivery, we can also set notifications to be delivered at a specific date and time.

**Presenters**. A presentor pattern to wrap deliveries in so the parent app will have an easier time working with a delivery. Could include assumptions about how to render the notification to text (specific to the specified deliver_via option).

**Expirations**. Set an expiration date on a message to make it no longer visible or valid.

**Retries**. Retry failed deliveries x times before giving up.

**Policies**. A policy document with a single method that further defines delivery rules or modes for a specific user. Useful for translating user preferences into Notify behaviors, such as if a user preference states they wish to not receive any notifications. In such a case, the notification and delivery are still created, but not passed on to the translator.

**Bundled delivery**. Bundle multiple notifications into a single delivery, configurable per delivery platform.

**Sticky notifications**. A sticky notification will appear at the top of a notification list.

**Throttled delivery**. Limit the number of notifications that can go out per minute, hour, or day. Limits can be enforced by skipping additional deliveries to a receiver that recently received a notification of the same type or postponing each delivery until the throttle time limit is reached. Throttling enforcement should be on the per-receiver level.

**Priority**. Mark a notification as more important relative to others. Higher priorities are executed sooner by a background queue.

**Deactivations**. One notification can deactivate another notification when the former is received or delivered. Most useful in visible notification lists.

**Send notifications to anything**. Set a notification receiver as anything, including non ActiveRecord objects. For example, if I wanted to send a notification out on a pubsub channel I would set the channel name as the receiver.

**Define translators quicker**. Perhaps change translators to use a different approach, but likely just add a helper method that creates the class in memory for you. Something like `Notify.define_translator :foo do #...`

**Generate Notify**. Add a generator that generates the necessities for running Notify. Initializer, receiver inclusion, etc. Could also add the option to generate the migrations in the app's migrations folder instead of the engine's.

---

v0.0.1

- Notification and delivery models, translators.
- Generators for notification and translator.

