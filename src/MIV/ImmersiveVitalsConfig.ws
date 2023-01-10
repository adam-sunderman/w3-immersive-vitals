enum IMMVCurve {
	IMMV_LINEAR = 0,
	IMMV_EXPONENTIAL = 1,
	IMMV_LOGARITHMIC = 2
}

struct IMMVIntensity {
	var magnitude: float;
	var curve: IMMVCurve;
}

struct IMMVStatConfig {
	var stat: EBaseCharacterStats;
	var enabled: bool;
	var intensity: IMMVIntensity;
	var reactivity: float;
}

struct IMMVHealingConfig {
	var enabled: bool;
	var intensity: IMMVIntensity;
	var maxHealPercentage: float;
}

function IMMV_getHealthConfig() : IMMVStatConfig
{
	var config: IMMVStatConfig;

	config.stat = BCS_Vitality;
	config.enabled = (bool) theGame.GetInGameConfigWrapper().GetVarValue('IMMVgeneral', 'IMMVhealthEffectEnabled');
	return config;
}

function IMMV_getStaminaConfig() : IMMVStatConfig
{
	var config: IMMVStatConfig;

	config.stat = BCS_Stamina;
	config.enabled = (bool) theGame.GetInGameConfigWrapper().GetVarValue('IMMVgeneral', 'IMMVstaminaBlurEnabled');
	return config;
}

function IMMVConfigGetCriticalHealthEffectIntensityMagnitude() : float
{
	var enabled: bool;
	var intensity: int;

	enabled = (bool) theGame.GetInGameConfigWrapper().GetVarValue('IMMVgeneral', 'IMMVhealthCriticalEffectEnabled');
	intensity = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('IMMVgeneral', 'IMMVhealthCriticalEffectIntensity'));

	return (float) enabled * ((float) intensity / 10.0f);
}