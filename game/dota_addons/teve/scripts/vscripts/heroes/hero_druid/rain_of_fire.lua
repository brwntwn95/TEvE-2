function RainOfFireStart( event )
	-- Variables
	local caster = event.caster
  local ability = event.ability
	local point = event.target_points[1]
  ability.point = point
end

function RainOfFireWave( event )
	local caster = event.caster
  local ability = event.ability
  local point = ability.point
  --Get your ability specials for radius and damage here
  local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
  local damage = ability:GetLevelSpecialValueFor("wave_damage", ability:GetLevel() - 1 )
  --Find enemy units in the radius, centering on the point
  local units = FindUnitsInRadius(caster:GetTeam(),
                              point,
                              nil,
                              radius,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
  --Iterate over the table with units and apply damage
  for _,unit in pairs(units) do
  	ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
  end
  --Particles
  local particle = ParticleManager:CreateParticle("particles/abilities/druid/firestorm/firestormgood.vpcf", PATTACH_WORLDORIGIN  , caster)
  ParticleManager:SetParticleControl(particle, 0, point) --[[Returns:void
  Set the control point data for a control on a particle effect
  ]]
  --Sound
  EmitSoundOnLocationWithCaster(point, "Hero_Jakiro.LiquidFire", caster) 
end