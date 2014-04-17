#### Questions 4 Scott

- Linear Motion via Box2D (energy is decreased on collision — might be fixed with restitution)



#### To do
- switch to continuous mode (add score for time!)
- use for loop to evenly distribute intitial circles
- change collision function to allow for different sized circles!!
- use if/else statement in draw loop to make targetScore and displaceScore
- make generation 'flicker' function that makes objects blink while they are intitally generate. During this time, they are will no effect the other objects. Make a boolean that sets all objects to 'responsive', and then if the object is blinking (or being intially generated), set the boolean to false so that the object won't interfere. Necessary when when a new ship is placed in the corner or a new circle is created.
- use geometry wars enemies as inspiration. Safety circles, linear movers (up+down or side-to-side), and attractors.
- add bonuses (invincibility, extra life, kill [1] body)
- safety circles will not shrink or expand; only disapper b/c scaling bodies is difficult. Add safety circles before attractors.
