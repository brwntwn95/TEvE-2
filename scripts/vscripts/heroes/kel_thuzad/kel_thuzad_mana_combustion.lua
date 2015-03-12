function ManaCombustion(keys)

	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local max_drain = ability:GetSpecialValueFor("max_drain")

	local damageTable = {}
	damageTable.attacker = caster
	damageTable.victim = target
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.ability = ability

	target_mana = target:GetMana()


	if(target_mana >= max_drain) then
		target:ReduceMana(max_drain)
		damageTable.damage = max_drain
	else
		target:ReduceMana(target_mana)
		damageTable.damage = target_mana
	end

	ApplyDamage(damageTable)


	local projectile = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_name,
		bDodgable = false,
		bProvidesVision = true,
		iMoveSpeed = projectile_speed,
		iVisionRasius = 0,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}

	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
	local particle_name = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"
	ProjectileManager:CreateTrackingProjectile(projectile)

end