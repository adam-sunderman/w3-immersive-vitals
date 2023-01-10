class VitalsDisplayManager {
	private var displayedStaminaPercent				: float;
		default displayedStaminaPercent = 1.0;
	private var numUpdatesOffStamina				: float;
		default numUpdatesOffStamina = 0.0;
	private var displayedHealthPercent				: float;
		default displayedHealthPercent = 1.0;
	private var numUpdatesOffHealth					: float;
		default numUpdatesOffHealth = 0.0;

	public function update() {
		var currentStaminaPercent : float;
		var currentHealthPercent : float;
		currentStaminaPercent = calculateStatPercent(BCS_Stamina);
		currentHealthPercent = calculateStatPercent(BCS_Vitality);

		if(currentStaminaPercent != displayedStaminaPercent) {
			displayedStaminaPercent = approachStatPercentage(currentStaminaPercent, displayedStaminaPercent, numUpdatesOffStamina, .001f);
			updateStaminaDisplay(displayedStaminaPercent);
			numUpdatesOffStamina += 1.0;
		} else {
			numUpdatesOffStamina = 0.0;
		}

		if(currentHealthPercent != displayedHealthPercent) {
			displayedHealthPercent = approachStatPercentage(currentHealthPercent, displayedHealthPercent, numUpdatesOffHealth, .00001f);
			updateHealthDisplay(displayedHealthPercent);
			numUpdatesOffHealth += 1.0;
		} else {
			numUpdatesOffHealth = 0.0;
		}

		if(!thePlayer.IsInCombat()) 
		{
			forceSetStatPercent(BCS_Vitality, approachStatPercentage(1.0f, currentHealthPercent, 1, 0.0005f));
		}

	}

	private function approachStatPercentage(targetStatPercent : float, currentStatPercent : float, numAttempts : float, factor : float) : float {
		if(targetStatPercent > currentStatPercent) {
			return MinF(targetStatPercent, (currentStatPercent + (factor * numAttempts)));
		} else {
			return MaxF(targetStatPercent, (currentStatPercent - (factor * numAttempts)));
		}
	}

	private function updateStaminaDisplay(staminaPercent : float) {
		FullscreenBlurSetup(0.75 - (0.75 * staminaPercent * staminaPercent * staminaPercent));
	}

	private function updateHealthDisplay(healthPercent : float) {
		var colorDrain : float;
		var redSky : float;
		colorDrain = 0.0;
		redSky = 0.075;

		if(!thePlayer.HasBuff(EET_Cat))
		{
			if(healthPercent < .98) {
				EnableCatViewFx( 1.0f );

				colorDrain = 1.0 - healthPercent;
				if(healthPercent < .5) {
					redSky = MaxF(redSky, 1.0 - (healthPercent * 2) - 0.25);
				}

				SetTintColorsCatViewFx(Vector(0.1f,0.12f,0.13f,0.6f),Vector(redSky,0.1f,0.11f,0.6f),colorDrain);
				SetBrightnessCatViewFx(20.0f);
				SetViewRangeCatViewFx(200.0f);
				SetPositionCatViewFx( Vector(0,0,0,0) , true );
				SetHightlightCatViewFx( Vector(0.3f,0.1f,0.1f,0.1f),0.05f,1.5f);
				SetFogDensityCatViewFx( 0.5 );
			} else {
				DisableCatViewFx( 2.0f );
			}
		}
	}

	private function calculateStatPercent(stat : EBaseCharacterStats) : float {
		var statPercent : float;

		statPercent = (float) thePlayer.GetStat( stat ) / (float) thePlayer.GetStatMax( stat );
		if(statPercent > .98) {
			statPercent = 1.0;
		}

		return statPercent;
	}
	
	private function forceSetStatPercent(stat : EBaseCharacterStats, percent : float) : void {
		var statRaw : float;
		percent = MinF(1.0f, percent);
		percent = MaxF(0.0f, percent);

		statRaw = (percent * (float) thePlayer.GetStatMax(stat)) / 1.0f;

		thePlayer.ForceSetStat(stat, statRaw);
	}
}