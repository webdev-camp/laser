Design
==============

Summary
-------

A weighted attribute matrix is a way of making a choice between
several options with many competiting criteria.

  * What score should this have? This involves lots of criteria such as
    downloads, activity, longevity etc.

A weighted attribute matrix is comprised of the following:

Options
:   These are the options you are trying to decide between. In the case of
    rating gems this could be: GemA, GemB, GemC..

Criteria
:   A way of assessing the options. In the case of
    ratings these could relate to: activity, popularity, downloads, recent commits, issues...

Weights
:   A numerical value which indicates the importance of a given option.
    For example, you may not care much about total activity, but you care a lot
    about recent commits. Often values of 0 (not important) to 5 (crucial/very important) will be used.

Scores
:   A numerical value which indicates how well an option (i.e. Gem1)
    satisfies a given criteria (i.e. recent activity). Often values of 0
    (does not satisfy at all) to 5 (completely satisfies) will be used.

Categories
:   Groups of criteria which can be useful for creating a high-level
    summary of how each option has scored.

Entities
--------

Core:

 * Option
 * Criteria
 * Weight
 * Score
 * Category

Additional:

 * Score labels - ability to give a specified criteria custom score labels
   (e.g: Version Downloads: 0 - 0 to 1000, 1 - 1000 to 5000, 2 - 5000 to 10000, 3 - 10000 to 20000,
   4 - 20000 to 100000, 5 - 1000000)
 * Allow multiple people to add user score & weight, then offer comparisons.
   * Link each weight to the given user
   * Link each score to the given user
 * Score modifiers??? - ability to specify a score, but then an alternate score given a modifier.
   For example, a 'downloads modifier' would allow for specifying a score of '0', but also a score of
   '3' given a modifier of 100000.
   * Example use: GemB has a user score of 0, but that could also be a score of 2
     if issue X was fixed.
 * **OR** - Use modifiers, but allow users to create entire alternative score
   sets for an option?


Calculation
--------------

Points for Criterion = (Criterion score * Criterion Weight)/MaxScore * Max Weight
Overall Rank of Option(gem) = Sum of Points for each Criterion/Number of Criterion

  gem a
commit activity score = 5 * weight 5 = 25/25 = 1
recent score = 3* weight 4 = 12/(5*5) = 0.48
forks = 4 * weight 3
