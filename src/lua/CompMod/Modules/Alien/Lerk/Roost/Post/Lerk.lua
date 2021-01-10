local networkVars = {
    lastTimeRoost = "compensated time"
}

Lerk.kRoostInterval = 1
Lerk.kRoostHealPercentage = 0.022

local oldOnCreate = Lerk.OnCreate
function Lerk:OnCreate()
    oldOnCreate(self)

    if Server then
        self.lastTimeRoost = 0
    end
end

function Lerk:OnProcessMove(input)
    Alien.OnProcessMove(self, input)

    self:UpdateRoostHeal()
end

function Lerk:UpdateRoostHeal()
    if not self:GetIsDestroyed() and self:GetIsAlive() then
        local roostAllowed = Shared.GetTime() > self.lastTimeRoost + Lerk.kRoostInterval

        if self:GetIsWallGripping() and roostAllowed and GetHasTech(self, kTechId.Roost, true) and not self:GetIsUnderFire() then
            self:AddHealth(self:GetMaxHealth() * self.kRoostHealPercentage, false, false, false, self, true)
            self.lastTimeRoost = Shared.GetTime()
        end
    end
end

Shared.LinkClassToMap("Lerk", Lerk.kMapName, networkVars, true)