Onboarding With UIPageController and UIStackViews
===================

A tutorial outlining how to create a typical onboarding flow with an alternative segmented control using UIStackViews. 



Why
-------------

You're probably thinking on-boarding screen... easy, just use `UIPageViewController`. Most people start implementing using `UIPageViewController` and then find out that it's not as robust as they first thought.  ie pages out of sync, bad states.  This implementation will even handle jerks mashing your navigation buttons.  The segmented control that it comes with ain't great either.  

`UIStackViews` provides an easy way to construct the segmented control from scratch.  The insertion of subviews gives you a free animation perfect for moving our dots.
