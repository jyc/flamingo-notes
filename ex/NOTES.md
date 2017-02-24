# Flamingo Notes

## Avoid Magic!

> There shall not be found among you any one that maketh his son or his daughter to pass through the fire, or that useth divination, or an observer of times, or an enchanter, or a witch, or a charmer, or a consulter with familiar spirits, or a wizard, or a necromancer.
> 
> &mdash; Deuteronomy 18:11

## Intro

This is a collection of notes I thought were worth writing down!

Sections with the note "Something to think about!" are things we haven't solved yet.
Sections with the note "Something to do!" are things we think we know how to solve and should try.

Also, it's worth reading Automated Planning by Ghallab, Nau, and Traverso.
Unfortunately they don't cover anything quite like our situation, but there is a lot of accumulated knowledge we should use to our advantage!

If possible, you should look at my last semester report. 
What we have now is heavily modified from that.

## Compound Clauses

*Something to think about!*

We want to be able to express that things should have happened, e.g. that at some point we saw an object.
We also want to express that things should have happened at the same time.

Easy!
We say that all of the predicates should express instantaneous truths.
For example, `see[X]` means that we see something at some moment in time.
Now we can define a language for complex clauses (simple clauses are just `p[X]`, a predicate and some arguments):

    e ::= p[X]
        | not(e)
        | was(e)
        | e1 & e2
        | e1 | e2

`was(e)` means that `e` was true at some time in the past.

`e1 & e2` means that `e1` and `e2` are simultaneously true in this instant.

`e1 | e2` means that either `e1` or `e2` is true in this instant.

Note that `was(a & was(b & c))` is *not* same as `was(a & b & c)`!
For example, `was(dead & was(breathing & alive))` makes sense, but `was(dead & breathing & alive)` is a nightmare.

*Insert formal definition using situation calculus when bored.*

> Has this already been formalized?

See also [temporal logic](https://en.wikipedia.org/wiki/Temporal_logic).

## Dependencies

*Something to think about!*

Clauses might have dependencies.
In particular,

	see[X]

... really means almost always:

	F(world) => see[X]

... where *F* is an function that takes in the state of the world and returns true if we can see *X* and false otherwise.

But it's hard to implement such a function *F*, especially in the presence of incomplete knowledge.

So what we actually have is:

	F(world) = E(world) > c
	
... where *E* is an *estimator* that takes in the state of the world and returns some probability that the clause in question is satisfied.

In the case of *see[X]*, the estimator should return some probability is highest if our position and orientation are similar to where we last saw the object.

We do want to be able to plan quickly, however.
We have to simplify the abstract states of the world into something we can deal with.

For now, we achieve that by splitting clauses into two classes: *latching* clauses, which once true remain true forevermore, and *volatile* clauses, which we assume can become invalidated by any action that doesn't explicitly preserve them.

Note that we assume that they won't become false in between actions, but that this is possible!
For example, `see[buoy]` is volatile.
But even if we don't do anything after we see it, maybe some external actor will remove the buoy, causing it to no longer be seen (or we just drift in the waves...)

We need to make two points about this:

1. We should never not be doing anything!
2. We have to be prepared to live with some uncertainty.

Remember that the vehicle is not intelligent like us.
It only has the limited model of the world we give it, which we have tried to make as tractable to plan in as possible.
If a primitive human caught a bird and then suddenly a meteor fell from the sky in front of him, he wouldn't be able to revise his plans for catching birds to account for when meteors might fall out of the sky!

So in this situation we go through the same confidence-adjustment procedure as before, but just as the primitive human might attribute the meteor falling to his catching the bird, we will unfortunately blame the specific action (which doesn't kill us &mdash; a down-adjustment in confidence just means we will try other things first).
If we make the model of the world more intelligent, then we can assign *blame* more accurately.

Also, these might be related to the idea of *modalities*, e.g. in modal logic!

> In standard formal approaches to linguistic modality, an utterance expressing modality is one that can always roughly be paraphrased to fit the following template:
> 
> (1) According to [a set of rules, wishes, beliefs,...] it is [necessary, possible] that [the main proposition] is the case. 
> 
> The set of propositions which forms the basis of evaluation is called the modal base. The result of the evaluation is called the modal force. For example the utterance in (2) expresses that, according to what the speaker has observed, it is necessary to conclude that John has a rather high income:
>
> (2) John must be earning a lot of money. 
> 
> &mdash; "Linguistic modality", Wikipedia

## Motion Planning

*Something to do.*

Note that there is a generic action that will try to implement `positioned[P]`!
This is the motion planning w/ constraints subsystem, which will try to satisfy the constraints `P` using the available sensors.

This sounds like a cop-out, but this is actually not more complex than the rest of the system.

For example, the constraint:

    positioned[above(D, banana) *
               within(z, DROP_DEPTH, 10%) *
               within((p, r), (0, 0), 10%)]
      D dropper


... wants to position *some* dropper *D*, both of whose positions are fixed relative to the sub and we know, relative to the *banana*, which is visible in the downwards camera.

In this case, the motion planning subsystem can implement this that is similar to what a person would do: require that we have `see[banana; at.cam=downcam]`, and then generate a path that takes `z` and `(h, p, r)` to what we specified *while keeping the banana in sight of the down cam so we can do this using closed-loop control!*
This might require rotating the sub (note we didn't constrain heading) depending on where *D*, the dropper, is positioned relative to the camera!

The naive way to do is this generate a lot of random in-between configurations (we can make them fit the constraints because we're generating them!) and then generate a desired ending configuration, and then find the shortest path between our current configuration and the ending configuration.
This corresponds to [sampling-based motion planning](https://en.wikipedia.org/wiki/Motion_planning#Sampling-Based_Algorithms)!

But depending on the constraints it might be able to just generate a path using some closed-form equation.

## Relative Times and Probabilities

*Something to do.*

It can be hard to come up with concrete ETAs and confidence values.
For example, without running many many tests, how are you supposed to decide if you should assign a confidence to an action that often fails of 10% or 5%?

Thankfully, we don't actually need concrete values to plan.
Finding the best path in the state graph actually only requires that we can compare costs.

## Goal Pruning

*Something to think about!*

Chris noted at the 10/22 meeting that it might end up that all actions that we could use to achieve a particular goal might end up to not work.
We'll adjust our confidence in their success downward, but if these are the only actions that can accomplish the goal and we are requiring that we achieve the goal, we will still be stuck trying to do one of these.

We should therefore have a principled way to prune goals that have become unfeasible.

Also, it might happen that we end up really close to our deadline.
In that case, the plan that achieves all of the goals in the shortest time might not give us the ideal situation in the time we have, and there might actually be no solution that achieves all the goals.
We should be able to plan in these circumstances too.

One way to do this would be to plan for different goals independently and then to chain those plans.
Then we can just do knapsack on these goals (points vs. remaining time).