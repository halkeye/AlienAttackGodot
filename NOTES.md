# Alien Attack Notes

## Todo

[x] Touch weaponsto switch weapons
[x] touch anywhere else to fire
[x] mouse and touch can work the same
[X] arrow keys to change weapons (as before)
[ ] Guns have cooldown/can only shoot once per second/delete old bullet create new one
[X] Add help to main menu
[X] make github action replace index.js to s/<script src="index.js">/<script src="index.js?m=timestamp">/
[X] ~black background~
[ ] make UFOs target between the two weapons(?)
[ ] Position things based on viewport?
[ ] Make UFOs have own firing timer, instead of firing one ufo in the scene

Timer:
  can_shoot = true
fire:
  can_shoot = false

Ufos respawn if they hit the edge and not all are dead yet
better luck next time, then game exits

	if (score_ >= roundno_ * WINNING_MULTIPLIER)
	{
		// yay! we've won!
		nextRound();
	}

ufo

	// Check for Collisions with Other UFOs
	for ( int c = 0; c < MAXUFOS; ++c )
	{
		UFO* ufo = Game::GetApp()->GetUfo(c);

		// Check for intersect
		if ( collision( ufo ) )
		{
			// If Other Isn't On Fire and We Are
			if ( ( status_ == UFO_BURN ) && ( ufo->getStatus() != UFO_BURN ) )
			{
				Game::GetApp()->IncScore();
			}
		}
	}
	
weapon

Weapon::Weapon(HINSTANCE h,int x, int y):ImageClass(h, IDR_FIRESTORMGUN)
{
	// if x coord is 0, why adjust it?
	basex_ = x;
	basey_ = y;
	
	// One Bullet per gun
	bullet = new Bullet(h);
	bullet->setX(-100);
	bullet->setY(-100);
	bullet->disabled();
	type_ = MAX_WEAPON; // unset
	count_ = 0;
}
