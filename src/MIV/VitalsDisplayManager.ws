class VitalsDisplayManager {
	private var displayedStaminaPercent				: float;
		default displayedStaminaPercent = 1.0;
	private var numUpdatesOffStamina				: float;
		default numUpdatesOffStamina = 0.0;
	private var displayedHealthPercent				: float;
		default displayedHealthPercent = 1.0;
	private var numUpdatesOffHealth					: float;
		default numUpdatesOffHealth = 0.0;
	private var healthConfig						: IMMVStatConfig;
	private var staminaConfig						: IMMVStatConfig;
	private var healConfig							: IMMVStatConfig;

	public function update() {
		var currentStaminaPercent : float;
		var currentHealthPercent : float;

		staminaConfig = IMMV_getStaminaConfig();
		healthConfig = IMMV_getHealthConfig();
		healConfig.stat = BCS_Vitality;
		healConfig.enabled = true;

		currentStaminaPercent = calculateStatPercent(staminaConfig);
		currentHealthPercent = calculateStatPercent(healthConfig);

		if(currentStaminaPercent != displayedStaminaPercent) {
			displayedStaminaPercent = approachStatPercentage(currentStaminaPercent, displayedStaminaPercent, numUpdatesOffStamina, .001f, staminaConfig);
			updateStaminaDisplay(displayedStaminaPercent);
			numUpdatesOffStamina += 1.0;
		} else {
			numUpdatesOffStamina = 0.0;
		}

		if(currentHealthPercent != displayedHealthPercent) {
			displayedHealthPercent = approachStatPercentage(currentHealthPercent, displayedHealthPercent, numUpdatesOffHealth, .00001f, healthConfig);
			updateHealthDisplay(displayedHealthPercent);
			numUpdatesOffHealth += 1.0;
		} else {
			numUpdatesOffHealth = 0.0;
		}

		if(!thePlayer.IsInCombat()) 
		{
			forceSetStatPercent(BCS_Vitality, approachStatPercentage(1.0f, currentHealthPercent, 1, 0.0005f, healConfig));
		}

	}

	private function approachStatPercentage(
			targetStatPercent : float, 
			currentStatPercent : float, 
			numAttempts : float, 
			factor : float,
			statConfig: IMMVStatConfig) : float {
		if(!statConfig.enabled) {
			return 1.0f;
		}

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
				EnableCatViewFx( 2.0f );

				colorDrain = 1.0f - healthPercent;
				if(healthPercent < .5f) {
					redSky = MaxF(
						redSky, 
						IMMVConfigGetCriticalHealthEffectIntensityMagnitude() - (healthPercent * 2.0f)
					);
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

	private function calculateStatPercent(statConfig: IMMVStatConfig) : float {
		var statPercent : float;

		statPercent = (float) thePlayer.GetStat( statConfig.stat ) / (float) thePlayer.GetStatMax( statConfig.stat );
		if(statPercent > .98f || !statConfig.enabled) {
			statPercent = 1.0f;
		}

		return statPercent;
	}
}

exec function SetVitality(percentage: string) {
	var statPercent: float;

	statPercent = StringToFloat(percentage) / 100.0f;

	forceSetStatPercent(BCS_Vitality, statPercent);
}

function forceSetStatPercent(stat : EBaseCharacterStats, percent : float) : void {
	var statRaw : float;
	percent = MinF(1.0f, percent);
	percent = MaxF(0.0f, percent);

	statRaw = (percent * (float) thePlayer.GetStatMax(stat)) / 1.0f;

	thePlayer.ForceSetStat(stat, statRaw);
}