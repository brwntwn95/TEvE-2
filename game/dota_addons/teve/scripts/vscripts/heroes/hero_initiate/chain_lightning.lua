function ChainLightning( event )

  local hero = event.caster
  local target = event.target
  local ability = event.ability

  local lasttarget = target

  local damage = ability:GetLevelSpecialValueFor( "lightning_damage", ability:GetLevel() - 1 )
  local bounces = ability:GetLevelSpecialValueFor( "lightning_bounces", ability:GetLevel() - 1 )
  local bounce_range = ability:GetLevelSpecialValueFor( "bounce_range", ability:GetLevel() - 1 )
  local decay = ability:GetLevelSpecialValueFor( "lightning_decay", ability:GetLevel() - 1 ) * 0.01
  local time_between_bounces = ability:GetLevelSpecialValueFor( "time_between_bounces", ability:GetLevel() - 1 )

  local lightningBolt = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_WORLDORIGIN, hero)
  ParticleManager:SetParticleControl(lightningBolt,0,Vector(hero:GetAbsOrigin().x,hero:GetAbsOrigin().y,hero:GetAbsOrigin().z + hero:GetBoundingMaxs().z )) 
  ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z )) 

  EmitSoundOn("Hero_Zuus.ArcLightning.Target", target)
  ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })

  local targetsStruck = {}
  target.struckByChain = true
  table.insert(targetsStruck,target)

  local units = nil

  Timers:CreateTimer(DoUniqueString("ChainLightning"), {
    endTime = time_between_bounces,
    callback = function()
  
      -- unit selection and counting
      units = FindUnitsInRadius(hero:GetTeamNumber(), target:GetOrigin(), target, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, true)

      -- Track the possible targets to bounce from the units in radius
      local possibleTargetsBounce = {}
      for _,v in pairs(units) do
        if not v.struckByChain then
          table.insert(possibleTargetsBounce,v)
        end
      end

      -- Select one of those targets at random
      target = possibleTargetsBounce[math.random(1,#possibleTargetsBounce)]
      if target then
        target.struckByChain = true
        table.insert(targetsStruck,target)    
      else
        -- There's no more targets left to bounce, clear the struck table and end
        for _,v in pairs(targetsStruck) do
            v.struckByChain = false
            v = nil
        end
          print("End Chain, no more targets")
        return  
      end  

      local lightningBolt = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_WORLDORIGIN, lasttarget)
      ParticleManager:SetParticleControl(lightningBolt,0,Vector(lasttarget:GetAbsOrigin().x,lasttarget:GetAbsOrigin().y,lasttarget:GetAbsOrigin().z + lasttarget:GetBoundingMaxs().z )) 
      ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z )) 
      
      -- damage and decay
      damage = damage - (damage*decay)
      ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
      print("Bounce "..bounces.." Hit Unit "..target:GetEntityIndex().. " for "..damage.." damage")

      -- play the sound
      EmitSoundOn("Hero_Zuus.ArcLightning.Target",target)

      lasttarget = target

      -- make the particle shoot to the target
  
      -- decrement remaining spell bounces
      bounces = bounces - 1

      -- fire the timer again if spell bounces remain
      if bounces > 0 then
        return time_between_bounces
      else
        for _,v in pairs(targetsStruck) do
            v.struckByChain = false
            v = nil
        end
        print("End Chain, no more bounces")
      end
    end
  })
end