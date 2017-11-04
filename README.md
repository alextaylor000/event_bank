# Event Bank

A hacky little bank app for creating accounts, depositing funds, making withdrawals. Built to play around with event sourcing architecture.

Caveat: I don't really know what I'm doing. The purpose of this project was to hack my way through building some simple commands using event sourcing in order to wrap my head around the concepts, before going off and looking at popular implementations or frameworks. _Wheeeee!_

## Architecture

After messing around for a bit, I eventually settled on an architecture pattern that ended up working really well within the context of Rails. 

First, we set up a single endpoint, `/api`, which accepts JSON:

```
  POST /api
  ---------
  {
    "command": "account_open",
    "data": {
      "account_owner_email": "alex@taylor.com"
    }
  }
```

Inside the [ApiController](https://github.com/alextaylor000/event_bank/blob/master/app/controllers/api_controller.rb), we handle the request by looking up the class that matches the requested `command`, and processing it:

```ruby
    command = params.fetch(:command)
    data = params.fetch(:data).to_json
    event_class = command.camelize.constantize

    result = event_class.new(data: data).process!

    render json: result
```

Processing the event does three things:
1. Validate the event - this ensures the action can be applied to the state correctly;
1. Apply any changes to the model;
1. Persist the event.

We only want to persist events which have succeeded. That way, we can replay the events later with confidence.

All events are stored in the `events` table, and we can take advantage of single-table-inheritance to allow for a really elegant expression of each event type:

```ruby
  class AccountOpen < Event
  class AccountDeposit < Event
  class AccountWithdraw < Event
```

The cool thing about this approach is how easy it makes adding new behaviour. Literally all you have to do is subclass `Event` and implement `#process`. No new controllers, no new routes, no modification of existing classes.

### Future
* Should the controller immediately persist some sort of Job/Command upon receiving a request? That way, we could retry if necessary. However, it would be tricky to make synchronous requests this way.


### Learnings / Questions

* One awesome lightbulb moment I had: you can leverage this event-driven architecture to make really expressive tests. When you're setting up an initial state in a test, usually you might rely on factories, which may have some callbacks, or maybe you directly create objects in the database. Here, you can just create and replay the same events that you would get in your production environment! :+1:
* I'm still not sure about the best way to handle the result of an event. E.g. when handling an "AccountOpen" event, should we respond with an "AccountCreated" event? Right now I'm just returning a hash from each event with some stuff I want to send back to the client, but there's probably a more structured way I could be doing this.
* Not sure how to go about error handling, either. If a withdrawal attempt is made and there are insufficient funds, should I emit an "InsufficientFunds" event?
* I'm still having a hard time wrapping my head around the separation of processing an event vs. updating the projection. Right now it feels like they're one in the same - i.e., the only thing I'm doing with an event is creating/updating an Account record. Maybe this is actually the idea though?

